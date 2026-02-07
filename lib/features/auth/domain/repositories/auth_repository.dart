import 'package:firebase_auth/firebase_auth.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in with Google OAuth
  /// Throws [AuthFailure] on error or cancellation
  Future<User> signInWithGoogle();

  /// Sign in with Apple OAuth
  /// Throws [AuthFailure] on error or cancellation
  Future<User> signInWithApple();

  /// Sign in or register with email and password
  /// Throws [AuthFailure] on error or invalid credentials
  Future<User> signInWithEmail(String email, String password, {bool register = false});

  /// Get current authenticated user
  User? get currentUser;

  /// Sign out from all providers
  Future<void> signOut();

  /// Get ID token for current user
  /// [forceRefresh] forces token refresh even if not expired
  Future<String?> getIdToken({bool forceRefresh = false});
}
