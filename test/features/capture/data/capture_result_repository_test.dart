import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

void main() {
  late Directory tempDir;
  late Box<CaptureResult> resultBox;
  late CaptureResultRepositoryImpl repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('result_repo_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CaptureResultAdapter());
    }
    resultBox = await Hive.openBox<CaptureResult>('capture_results_test');
    repository = CaptureResultRepositoryImpl(resultBox: resultBox);
  });

  tearDown(() async {
    await resultBox.close();
    await Hive.deleteBoxFromDisk('capture_results_test');
    await tempDir.delete(recursive: true);
  });

  test('saveResult writes and sorts by savedAt', () async {
    final first = CaptureResult(jobId: '1', savedAt: DateTime(2024, 5));
    final second = CaptureResult(jobId: '2', savedAt: DateTime(2024, 6));

    await repository.saveResult(first);
    await repository.saveResult(second);

    final all = repository.allSorted();
    expect(all.first.jobId, '2');
    expect(repository.findByJobId('1')?.jobId, '1');
  });

  test('findByJobId returns correct result', () async {
    final result = CaptureResult(jobId: 'test-id', savedAt: DateTime.now());
    await repository.saveResult(result);

    final found = repository.findByJobId('test-id');
    expect(found?.jobId, 'test-id');
    expect(repository.findByJobId('non-existent'), isNull);
  });
}
