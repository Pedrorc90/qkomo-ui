import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_cache.dart';

class FeatureToggleHiveBoxes {
  static const String togglesBox = 'feature_toggles';
  static const String metadataBox = 'feature_toggle_metadata';

  // Keys within the boxes
  static const String togglesKey = 'all_toggles';
  static const String metadataKey = 'cache_metadata';

  static Future<void> init([Uint8List? encryptionKey]) async {
    // Register adapters
    Hive.registerAdapter(FeatureToggleAdapter());
    Hive.registerAdapter(FeatureToggleCacheMetadataAdapter());

    final cipher = encryptionKey != null ? HiveAesCipher(encryptionKey) : null;

    // Open boxes
    await Hive.openBox<FeatureToggle>(togglesBox, encryptionCipher: cipher);
    await Hive.openBox<FeatureToggleCacheMetadata>(metadataBox, encryptionCipher: cipher);
  }
}
