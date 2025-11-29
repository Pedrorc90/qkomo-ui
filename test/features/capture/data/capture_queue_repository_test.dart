import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/capture/data/capture_queue_repository.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_status_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_type_adapter.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_status.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';

void main() {
  late Directory tempDir;
  late Box<CaptureJob> jobBox;
  late CaptureQueueRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('queue_repo_test');
    Hive.init(tempDir.path);
    _registerAdapters();
    jobBox = await Hive.openBox<CaptureJob>('capture_jobs_test');
    repository = CaptureQueueRepository(jobBox: jobBox);
  });

  tearDown(() async {
    await jobBox.close();
    await Hive.deleteBoxFromDisk('capture_jobs_test');
    await tempDir.delete(recursive: true);
  });

  test('enqueueImage stores a pending job', () async {
    final job = await repository.enqueueImage('/tmp/image.jpg');

    expect(job.type, CaptureJobType.image);
    expect(job.status, CaptureJobStatus.pending);
    expect(repository.pendingJobs().map((e) => e.id), contains(job.id));
  });

  test('enqueueBarcode stores a pending job', () async {
    final job = await repository.enqueueBarcode('12345');

    expect(job.type, CaptureJobType.barcode);
    expect(job.barcode, '12345');
  });

  test('markFailure increments attempts and stores error', () async {
    final job = await repository.enqueueBarcode('abc');

    await repository.markFailure(job.id, 'timeout');

    final stored = jobBox.get(job.id)!;
    expect(stored.status, CaptureJobStatus.failed);
    expect(stored.attempts, 1);
    expect(stored.lastError, 'timeout');
  });

  test('markSuccess updates status and timestamp', () async {
    final job = await repository.enqueueImage('/tmp/image.jpg');

    await repository.markSuccess(job.id);

    final stored = jobBox.get(job.id)!;
    expect(stored.status, CaptureJobStatus.succeeded);
    expect(stored.updatedAt, isNotNull);
  });
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CaptureJobAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(CaptureJobStatusAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(CaptureJobTypeAdapter());
  }
}
