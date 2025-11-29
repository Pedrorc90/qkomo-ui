import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/capture/application/capture_queue_processor.dart';
import 'package:qkomo_ui/features/capture/data/capture_queue_repository.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_status_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_type_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/capture/domain/capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_status.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

class _FakeAnalyzer implements CaptureAnalyzer {
  _FakeAnalyzer({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<CaptureResult> analyze(CaptureJob job) async {
    if (shouldFail) throw Exception('fail');
    return CaptureResult(jobId: job.id, savedAt: DateTime(2024, 1, 1));
  }
}

void main() {
  late Directory tempDir;
  late Box<CaptureJob> jobBox;
  late Box<CaptureResult> resultBox;
  late CaptureQueueRepository queueRepo;
  late CaptureResultRepository resultRepo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('queue_processor_test');
    Hive.init(tempDir.path);
    _registerAdapters();
    jobBox = await Hive.openBox<CaptureJob>('jobs');
    resultBox = await Hive.openBox<CaptureResult>('results');
    queueRepo = CaptureQueueRepository(jobBox: jobBox);
    resultRepo = CaptureResultRepository(resultBox: resultBox);
  });

  tearDown(() async {
    await jobBox.close();
    await resultBox.close();
    await Hive.deleteBoxFromDisk('jobs');
    await Hive.deleteBoxFromDisk('results');
    await tempDir.delete(recursive: true);
  });

  test('processPending saves results and marks success', () async {
    await queueRepo.enqueueImage('/tmp/image.jpg');
    final processor = CaptureQueueProcessor(
      queueRepository: queueRepo,
      resultRepository: resultRepo,
      analyzer: _FakeAnalyzer(),
    );

    final processed = await processor.processPending();

    expect(processed, 1);
    final storedJob = jobBox.values.first;
    expect(storedJob.status, CaptureJobStatus.succeeded);
    expect(resultRepo.findByJobId(storedJob.id), isNotNull);
  });

  test('processPending marks failure when analyzer throws', () async {
    final job = await queueRepo.enqueueBarcode('123');
    final processor = CaptureQueueProcessor(
      queueRepository: queueRepo,
      resultRepository: resultRepo,
      analyzer: _FakeAnalyzer(shouldFail: true),
    );

    final processed = await processor.processPending();

    expect(processed, 0);
    final storedJob = jobBox.get(job.id)!;
    expect(storedJob.status, CaptureJobStatus.failed);
    expect(storedJob.attempts, 1);
  });
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
