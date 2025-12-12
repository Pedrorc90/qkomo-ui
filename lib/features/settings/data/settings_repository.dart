import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

class SettingsRepository {
  static const String boxName = 'user_settings_box';
  static const String settingsKey = 'current_settings';

  Future<Box<UserSettings>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<UserSettings>(boxName);
    }
    return Hive.box<UserSettings>(boxName);
  }

  Future<UserSettings> loadSettings() async {
    final box = await _getBox();
    final settings = box.get(settingsKey);
    if (settings == null) {
      // Return default settings if none exist
      const defaultSettings = UserSettings();
      await saveSettings(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  Future<void> saveSettings(UserSettings settings) async {
    final box = await _getBox();
    await box.put(settingsKey, settings);
  }

  Future<void> clearSettings() async {
    final box = await _getBox();
    await box.delete(settingsKey);
  }
}
