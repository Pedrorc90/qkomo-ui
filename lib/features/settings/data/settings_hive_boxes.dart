import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

class SettingsHiveBoxes {
  static const userSettings = 'user_settings_box';

  static Future<void> init([Uint8List? encryptionKey]) async {
    Hive
      ..registerAdapter(UserSettingsImplAdapter())
      ..registerAdapter(AllergenAdapter())
      ..registerAdapter(DietaryRestrictionAdapter());

    final cipher = encryptionKey != null ? HiveAesCipher(encryptionKey) : null;

    // Open as dynamic box since it stores both UserSettings and bool values
    // (current_settings and first_sync_completed flag)
    await Hive.openBox<dynamic>(userSettings, encryptionCipher: cipher);
  }
}
