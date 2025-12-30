import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/profile/data/profile_hive_boxes.dart';
import 'package:qkomo_ui/features/profile/domain/user_profile.dart';

/// Local repository for user profile using Hive storage
///
/// Stores UserProfile in a dynamic box with a single profile key.
/// Pattern follows LocalSettingsRepository implementation.
class LocalUserProfileRepository {
  /// Key for storing the current user profile
  static const String profileKey = 'current_profile';

  /// Key for tracking first sync completion
  static const String firstSyncKey = 'first_sync_completed';

  /// Get the Hive box, opening it if not already open
  Future<Box<dynamic>> _getBox() async {
    if (!Hive.isBoxOpen(ProfileHiveBoxes.userProfile)) {
      return Hive.openBox<dynamic>(ProfileHiveBoxes.userProfile);
    }
    return Hive.box<dynamic>(ProfileHiveBoxes.userProfile);
  }

  /// Load user profile from local storage
  ///
  /// Returns null if no profile exists.
  Future<UserProfile?> loadProfile() async {
    final box = await _getBox();
    return box.get(profileKey) as UserProfile?;
  }

  /// Save user profile to local storage
  Future<void> saveProfile(UserProfile profile) async {
    final box = await _getBox();
    await box.put(profileKey, profile);
  }

  /// Clear user profile from local storage
  ///
  /// Called on logout.
  Future<void> clearProfile() async {
    final box = await _getBox();
    await box.delete(profileKey);
  }

  /// Mark first sync completed (migration pattern)
  ///
  /// Note: Not currently used since UserProfile is read-only from client,
  /// but kept for consistency with other repositories.
  Future<void> markFirstSyncCompleted() async {
    final box = await _getBox();
    await box.put(firstSyncKey, true);
  }

  /// Check if first sync completed
  Future<bool> isFirstSyncCompleted() async {
    final box = await _getBox();
    return box.get(firstSyncKey, defaultValue: false) as bool;
  }

  /// Reset first sync flag (for testing)
  Future<void> resetFirstSyncFlag() async {
    final box = await _getBox();
    await box.delete(firstSyncKey);
  }
}
