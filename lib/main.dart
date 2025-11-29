import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'features/capture/data/hive_adapters/capture_job_adapter.dart';
import 'features/capture/data/hive_adapters/capture_job_status_adapter.dart';
import 'features/capture/data/hive_adapters/capture_job_type_adapter.dart';
import 'features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'features/capture/data/hive_boxes.dart';
import 'features/capture/domain/capture_job.dart';
import 'features/capture/domain/capture_result.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initHive();
  runApp(const ProviderScope(child: qkomoApp()));
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  _registerAdapters();
  await Hive.openBox<CaptureJob>(HiveBoxes.captureJobs);
  await Hive.openBox<CaptureResult>(HiveBoxes.captureResults);
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CaptureJobAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CaptureResultAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(CaptureJobStatusAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(CaptureJobTypeAdapter());
  }
}
