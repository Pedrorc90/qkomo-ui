import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

import '../../../core/http/dio_provider.dart';
import '../../auth/application/auth_providers.dart';
import 'backend_capture_analyzer.dart';
import 'capture_controller.dart';
import 'capture_enqueue_controller.dart';
import 'capture_queue_service.dart';
import 'capture_queue_processor.dart';
import 'capture_queue_process_controller.dart';
import 'capture_permissions.dart';
import 'capture_state.dart';
import '../data/capture_api_client.dart';
import '../data/capture_queue_repository.dart';
import '../data/capture_result_repository.dart';
import '../data/hive_boxes.dart';
import '../domain/capture_job.dart';
import '../domain/capture_result.dart';
import '../domain/capture_job_status.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final capturePermissionsProvider = Provider<CapturePermissions>((ref) {
  return CapturePermissions();
});

final captureControllerProvider =
    StateNotifierProvider<CaptureController, CaptureState>((ref) {
  final picker = ref.watch(imagePickerProvider);
  final permissions = ref.watch(capturePermissionsProvider);
  return CaptureController(picker, permissions);
});

final captureJobBoxProvider = Provider<Box<CaptureJob>>((ref) {
  return Hive.box<CaptureJob>(HiveBoxes.captureJobs);
});

final captureResultBoxProvider = Provider<Box<CaptureResult>>((ref) {
  return Hive.box<CaptureResult>(HiveBoxes.captureResults);
});

final captureQueueRepositoryProvider = Provider<CaptureQueueRepository>((ref) {
  final box = ref.watch(captureJobBoxProvider);
  return CaptureQueueRepository(jobBox: box);
});

final captureResultRepositoryProvider = Provider<CaptureResultRepository>((ref) {
  final box = ref.watch(captureResultBoxProvider);
  return CaptureResultRepository(resultBox: box);
});

final captureApiClientProvider = Provider<CaptureApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final FirebaseAuth auth = ref.watch(firebaseAuthProvider);
  return CaptureApiClient(dio: dio, auth: auth);
});

final captureQueueServiceProvider = Provider<CaptureQueueService>((ref) {
  final queueRepo = ref.watch(captureQueueRepositoryProvider);
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  return CaptureQueueService(
    queueRepository: queueRepo,
    resultRepository: resultRepo,
  );
});

final captureAnalyzerProvider = Provider((ref) {
  final apiClient = ref.watch(captureApiClientProvider);
  return BackendCaptureAnalyzer(apiClient);
});

final captureQueueProcessorProvider = Provider<CaptureQueueProcessor>((ref) {
  final queueRepo = ref.watch(captureQueueRepositoryProvider);
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  final analyzer = ref.watch(captureAnalyzerProvider);
  return CaptureQueueProcessor(
    queueRepository: queueRepo,
    resultRepository: resultRepo,
    analyzer: analyzer,
  );
});

final captureEnqueueControllerProvider =
    StateNotifierProvider<CaptureEnqueueController, AsyncValue<CaptureJob?>>((ref) {
  final service = ref.watch(captureQueueServiceProvider);
  return CaptureEnqueueController(service);
});

final captureQueueProcessControllerProvider =
    StateNotifierProvider<CaptureQueueProcessController, AsyncValue<int>>((ref) {
  final processor = ref.watch(captureQueueProcessorProvider);
  return CaptureQueueProcessController(processor);
});

final pendingCaptureJobsProvider = StreamProvider<List<CaptureJob>>((ref) {
  final box = ref.watch(captureJobBoxProvider);

  List<CaptureJob> _buildPending() {
    return box.values
        .where((job) => job.status == CaptureJobStatus.pending)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  final controller = StreamController<List<CaptureJob>>();
  controller.add(_buildPending());
  final sub = box.watch().listen((_) {
    controller.add(_buildPending());
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

final captureResultsProvider = StreamProvider<List<CaptureResult>>((ref) {
  final box = ref.watch(captureResultBoxProvider);

  List<CaptureResult> _sorted() {
    final items = box.values.toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  final controller = StreamController<List<CaptureResult>>();
  controller.add(_sorted());
  final sub = box.watch().listen((_) => controller.add(_sorted()));

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
