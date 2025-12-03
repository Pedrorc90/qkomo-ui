import 'package:hive_flutter/hive_flutter.dart';

import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_status_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_type_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/menu/data/hive_adapters/meal_type_adapter.dart';

class HiveBoxes {
  static const captureJobs = 'capture_jobs';
  static const captureResults = 'capture_results';
  static const entries = 'entries';

  static Future<void> init() async {
    Hive.registerAdapter(CaptureJobAdapter());
    Hive.registerAdapter(CaptureJobTypeAdapter());
    Hive.registerAdapter(CaptureJobStatusAdapter());
    Hive.registerAdapter(CaptureResultAdapter());
    Hive.registerAdapter(MealTypeAdapter());
    Hive.registerAdapter(EntryAdapter());
    Hive.registerAdapter(SyncStatusAdapter());

    await Hive.openBox<CaptureJob>(captureJobs);
    await Hive.openBox<CaptureResult>(captureResults);
    await Hive.openBox<Entry>(entries);
  }
}
