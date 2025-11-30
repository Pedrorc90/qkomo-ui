import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/application/capture_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_enqueue_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_queue_service.dart';
import 'package:qkomo_ui/features/capture/application/capture_queue_processor.dart';
import 'package:qkomo_ui/features/capture/application/capture_queue_process_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_permissions.dart';
import 'package:qkomo_ui/features/capture/application/capture_review_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/application/text_entry_controller.dart';
import 'package:qkomo_ui/features/capture/application/direct_analyze_controller.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/capture_queue_repository.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/data/hive_boxes.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_status.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final capturePermissionsProvider = Provider<CapturePermissions>((ref) {
  return CapturePermissions();
});

final captureControllerProvider = StateNotifierProvider<CaptureController, CaptureState>((ref) {
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
  return CaptureApiClient(dio: dio);
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
  final queueRepo = ref.watch(captureQueueRepositoryProvider);
  return CaptureQueueProcessController(processor, queueRepo);
});

final pendingCaptureJobsProvider = StreamProvider<List<CaptureJob>>((ref) {
  final box = ref.watch(captureJobBoxProvider);

  List<CaptureJob> _buildPending() {
    return box.values.where((job) => job.status == CaptureJobStatus.pending).toList()
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

final failedCaptureJobsProvider = StreamProvider<List<CaptureJob>>((ref) {
  final box = ref.watch(captureJobBoxProvider);

  List<CaptureJob> _buildFailed() {
    return box.values.where((job) => job.status == CaptureJobStatus.failed).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  final controller = StreamController<List<CaptureJob>>();
  controller.add(_buildFailed());
  final sub = box.watch().listen((_) {
    controller.add(_buildFailed());
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

final processingCaptureJobsProvider = StreamProvider<List<CaptureJob>>((ref) {
  final box = ref.watch(captureJobBoxProvider);

  List<CaptureJob> _buildProcessing() {
    return box.values.where((job) => job.status == CaptureJobStatus.processing).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  final controller = StreamController<List<CaptureJob>>();
  controller.add(_buildProcessing());
  final sub = box.watch().listen((_) {
    controller.add(_buildProcessing());
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Provides queue statistics (pending, failed, processing counts)
final queueStatsProvider = StreamProvider<QueueStats>((ref) {
  final box = ref.watch(captureJobBoxProvider);

  QueueStats _buildStats() {
    var pending = 0;
    var failed = 0;
    var processing = 0;

    for (final job in box.values) {
      switch (job.status) {
        case CaptureJobStatus.pending:
          pending++;
          break;
        case CaptureJobStatus.failed:
          failed++;
          break;
        case CaptureJobStatus.processing:
          processing++;
          break;
        case CaptureJobStatus.succeeded:
          // Don't count succeeded jobs
          break;
      }
    }

    return QueueStats(
      pending: pending,
      failed: failed,
      processing: processing,
    );
  }

  final controller = StreamController<QueueStats>();
  controller.add(_buildStats());
  final sub = box.watch().listen((_) {
    controller.add(_buildStats());
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Queue statistics data class
class QueueStats {
  const QueueStats({
    required this.pending,
    required this.failed,
    required this.processing,
  });

  final int pending;
  final int failed;
  final int processing;

  int get total => pending + failed + processing;
}

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

final textEntryControllerProvider =
    StateNotifierProvider<TextEntryController, AsyncValue<CaptureResult?>>((ref) {
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  return TextEntryController(resultRepo);
});

final captureReviewControllerProvider =
    StateNotifierProvider.family<CaptureReviewController, CaptureReviewState, String>(
        (ref, resultId) {
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  final entryRepo = ref.watch(entryRepositoryProvider);
  return CaptureReviewController(
    resultId: resultId,
    resultRepository: resultRepo,
    entryRepository: entryRepo,
  );
});

final directAnalyzeControllerProvider =
    StateNotifierProvider<DirectAnalyzeController, AsyncValue<String?>>((ref) {
  final analyzer = ref.watch(captureAnalyzerProvider);
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  return DirectAnalyzeController(analyzer, resultRepo);
});
