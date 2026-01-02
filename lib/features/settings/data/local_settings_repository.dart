import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/settings/domain/repositories/settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/entities/user_settings.dart';

/// Local implementation of SettingsRepository using Hive for persistence
///
/// Stores user settings in a Hive box with keys:
/// - 'current_settings': UserSettings object
/// - 'first_sync_completed': Boolean flag for migration tracking
class LocalSettingsRepository implements SettingsRepository {
  static const String boxName = 'user_settings_box';
  static const String settingsKey = 'current_settings';
  static const String firstSyncKey = 'first_sync_completed';

  Future<Box<dynamic>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return Hive.openBox<dynamic>(boxName);
    }
    return Hive.box<dynamic>(boxName);
  }

  @override
  Future<UserSettings> loadSettings() async {
    final box = await _getBox();
    final settings = box.get(settingsKey) as UserSettings?;
    if (settings == null) {
      // Return default settings if none exist
      const defaultSettings = UserSettings();
      await saveSettings(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    final box = await _getBox();
    await box.put(settingsKey, settings);
  }

  @override
  Future<void> clearSettings() async {
    final box = await _getBox();
    await box.delete(settingsKey);
  }

  /// Mark that first sync with backend has been completed
  ///
  /// Used for migration: on first sync after update, local settings are pushed
  /// to backend. On subsequent syncs, backend is source of truth.
  Future<void> markFirstSyncCompleted() async {
    final box = await _getBox();
    await box.put(firstSyncKey, true);
  }

  /// Check if first sync with backend has been completed
  ///
  /// Returns false if this is the first time syncing after app update,
  /// indicating that local settings should be pushed to backend.
  Future<bool> isFirstSyncCompleted() async {
    final box = await _getBox();
    return box.get(firstSyncKey, defaultValue: false) as bool;
  }

  /// Reset first sync flag (useful for testing or re-migration)
  Future<void> resetFirstSyncFlag() async {
    final box = await _getBox();
    await box.delete(firstSyncKey);
  }
}
