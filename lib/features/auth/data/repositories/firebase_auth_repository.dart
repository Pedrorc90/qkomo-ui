import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/auth/domain/errors/auth_failure.dart';
import 'package:qkomo_ui/features/auth/domain/repositories/auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth auth,
  }) : _auth = auth;

  final FirebaseAuth _auth;
  final GoogleSignIn? _googleSignIn =
      (kIsWeb || !FeatureFlags.googleAuth) ? null : GoogleSignIn(scopes: ['email']);

  @override
  Future<User> signInWithGoogle() async {
    if (!FeatureFlags.googleAuth) {
      throw const AuthFailure('Google Sign-In no está disponible');
    }

    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final credential = await _auth.signInWithPopup(googleProvider);
        final user = credential.user;
        if (user == null) {
          throw const AuthFailure('No se pudo obtener usuario');
        }
        return user;
      }

      final googleUser = await _googleSignIn?.signIn();
      if (googleUser == null) {
        throw const AuthFailure('Inicio cancelado');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) {
        throw const AuthFailure('No se pudo obtener usuario');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'No se pudo iniciar sesión con Google');
    }
  }

  @override
  Future<User> signInWithApple() async {
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
      final user = result.user;
      if (user == null) {
        throw const AuthFailure('No se pudo obtener usuario');
      }
      return user;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthFailure('Inicio cancelado');
      }
      throw AuthFailure(e.message);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Apple Sign-In falló');
    }
  }

  @override
  Future<User> signInWithEmail(String email, String password,
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

      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('No se pudo obtener usuario');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Error de autenticación');
    }
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await _googleSignIn?.signOut();
    }
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }
}
