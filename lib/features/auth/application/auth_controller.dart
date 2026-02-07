import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:qkomo_ui/features/auth/application/secure_token_store.dart';
import 'package:qkomo_ui/features/auth/domain/repositories/auth_repository.dart';
import 'package:qkomo_ui/features/profile/domain/repositories/user_profile_repository.dart';

class AuthController {
  AuthController({
    required AuthRepository authRepo,
    required SecureTokenStore tokenStore,
    required VoidCallback onTokenChanged,
    required UserProfileRepository userProfileRepo,
  })  : _authRepo = authRepo,
        _tokenStore = tokenStore,
        _onTokenChanged = onTokenChanged,
        _userProfileRepo = userProfileRepo;

  final AuthRepository _authRepo;
  final SecureTokenStore _tokenStore;
  final VoidCallback _onTokenChanged;
  final UserProfileRepository _userProfileRepo;

  Future<void> signInWithGoogle() async {
    final user = await _authRepo.signInWithGoogle();
    await _persistToken(user);
  }

  Future<void> signInWithApple() async {
    final user = await _authRepo.signInWithApple();
    await _persistToken(user);
  }

  Future<void> signInWithEmail(String email, String password,
      {bool register = false}) async {
    final user = await _authRepo.signInWithEmail(email, password, register: register);
    await _persistToken(user);
  }

  Future<void> refreshIdToken() async {
    final token = await _authRepo.getIdToken(forceRefresh: true);
    if (token != null) {
      await _tokenStore.save(token);
      _notifyTokenChanged();
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    await _tokenStore.clear();

    // Clear user profile on logout
    await _userProfileRepo.clearProfile();

    _notifyTokenChanged();
  }

  Future<void> _persistToken(User user) async {
    final token = await user.getIdToken();
    if (token == null) return;

    await _tokenStore.save(token);
    _notifyTokenChanged();

    // Trigger UserProfile sync after successful login
    // This is necessary because UserProfileNotifier only syncs when authenticated
    await _userProfileRepo.triggerSync();
  }

  void _notifyTokenChanged() => _onTokenChanged();
}
