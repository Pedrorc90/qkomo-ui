import 'package:hive_flutter/hive_flutter.dart';

import '../../entry/domain/entry.dart';
import '../../entry/domain/sync_status.dart';
import '../domain/capture_job.dart';
import '../domain/capture_job_status.dart';
import '../domain/capture_job_type.dart';
import '../domain/capture_result.dart';
import '../../menu/domain/meal_type.dart';

import 'hive_adapters/capture_job_adapter.dart';
import 'hive_adapters/capture_job_status_adapter.dart';
import 'hive_adapters/capture_job_type_adapter.dart';
import 'hive_adapters/capture_result_adapter.dart';
import '../../menu/data/hive_adapters/meal_type_adapter.dart';

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
