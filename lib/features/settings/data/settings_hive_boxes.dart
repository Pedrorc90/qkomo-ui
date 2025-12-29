import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

class SettingsHiveBoxes {
  static const userSettings = 'user_settings_box';

  static Future<void> init() async {
    Hive
      ..registerAdapter(UserSettingsImplAdapter())
      ..registerAdapter(AllergenAdapter())
      ..registerAdapter(DietaryRestrictionAdapter());

    // Open as dynamic box since it stores both UserSettings and bool values
    // (current_settings and first_sync_completed flag)
    await Hive.openBox<dynamic>(userSettings);
  }
}
