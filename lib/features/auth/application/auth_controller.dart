import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qkomo_ui/features/auth/application/secure_token_store.dart';
import 'package:qkomo_ui/features/auth/domain/auth_failure.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController {
  AuthController({
    required FirebaseAuth auth,
    required SecureTokenStore tokenStore,
    required VoidCallback onTokenChanged,
  })  : _auth = auth,
        _tokenStore = tokenStore,
        _onTokenChanged = onTokenChanged;

  final FirebaseAuth _auth;
  final SecureTokenStore _tokenStore;
  final VoidCallback _onTokenChanged;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final credential = await _auth.signInWithPopup(googleProvider);
        await _persistToken(credential.user);
        return;
      }
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure('Inicio cancelado');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      await _persistToken(result.user);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'No se pudo iniciar sesión con Google');
    }
  }

  Future<void> signInWithApple() async {
    if (kIsWeb) {
      throw const AuthFailure('Apple Sign-In no está disponible en web');
    }
    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      throw const AuthFailure(
          'Apple Sign-In solo está disponible en dispositivos Apple');
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final result = await _auth.signInWithCredential(oauthCredential);
      await _persistToken(result.user);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthFailure('Inicio cancelado');
      }
      throw AuthFailure(e.message);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Apple Sign-In falló');
    }
  }

  Future<void> signInWithEmail(String email, String password,
      {bool register = false}) async {
    if (email.isEmpty || password.isEmpty) {
      throw const AuthFailure('Email y contraseña son obligatorios');
    }
    try {
      UserCredential credential;
      if (register) {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      await _persistToken(credential.user);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Error de autenticación');
    }
  }

  Future<void> refreshIdToken() async {
    await _persistToken(_auth.currentUser, forceRefresh: true);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _tokenStore.clear();
    _notifyTokenChanged();
  }

  Future<void> _persistToken(User? user, {bool forceRefresh = false}) async {
    if (user == null) {
      await _tokenStore.clear();
      _notifyTokenChanged();
      return;
    }
    final token = await user.getIdToken(forceRefresh);
    await _tokenStore.save(token);
    _notifyTokenChanged();
  }

  void _notifyTokenChanged() => _onTokenChanged();
}
