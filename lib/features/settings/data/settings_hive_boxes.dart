import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

class SettingsHiveBoxes {
  static const userSettings = 'user_settings_box';

  static Future<void> init() async {
    Hive.registerAdapter(UserSettingsImplAdapter());
    Hive.registerAdapter(AllergenAdapter());
    Hive.registerAdapter(DietaryRestrictionAdapter());

    // We don't open the box here necessarily, as the repo manages it,
    // but opening it early doesn't hurt.
    await Hive.openBox<UserSettings>(userSettings);
  }
}
