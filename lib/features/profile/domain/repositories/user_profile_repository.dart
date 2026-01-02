import 'package:qkomo_ui/features/profile/domain/entities/user_profile.dart';

/// Abstract repository interface for user profile operations
///
/// Implementations should follow offline-first pattern:
/// - Return local data immediately
/// - Sync with backend asynchronously in background
abstract class UserProfileRepository {
  /// Load user profile (returns local immediately, syncs in background)
  ///
  /// Returns null if no profile exists locally.
  Future<UserProfile?> loadProfile();

  /// Save user profile locally
  Future<void> saveProfile(UserProfile profile);

  /// Clear local profile (called on logout)
  Future<void> clearProfile();

  /// Trigger background sync (fire-and-forget)
  ///
  /// Fetches profile from backend and updates local storage.
  /// Silent failure - does not throw errors.
  Future<void> triggerSync();
}
