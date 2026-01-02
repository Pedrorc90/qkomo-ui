import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/data/hive_adapters/meal_type_adapter.dart';

class HiveBoxes {
  static const captureResults = 'capture_results';
  static const entries = 'entries';

  static Future<void> init([Uint8List? encryptionKey]) async {
    Hive.registerAdapter(CaptureResultAdapter());
    Hive.registerAdapter(MealTypeAdapter());
    Hive.registerAdapter(EntryAdapter());
    Hive.registerAdapter(SyncStatusAdapter());

    final cipher = encryptionKey != null ? HiveAesCipher(encryptionKey) : null;

    await Hive.openBox<CaptureResult>(captureResults, encryptionCipher: cipher);
    await Hive.openBox<Entry>(entries, encryptionCipher: cipher);
  }
}
