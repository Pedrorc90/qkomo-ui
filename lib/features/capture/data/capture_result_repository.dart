import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

class CaptureResultRepositoryImpl implements CaptureResultRepository {
  CaptureResultRepositoryImpl({required Box<CaptureResult> resultBox})
      : _resultBox = resultBox;

  final Box<CaptureResult> _resultBox;

  @override
  Future<void> saveResult(CaptureResult result) async {
    await _resultBox.put(result.jobId, result);
  }

  @override
  CaptureResult? findByJobId(String jobId) {
    return _resultBox.get(jobId);
  }

  @override
  List<CaptureResult> allSorted() {
    final items = _resultBox.values.toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  @override
  Stream<List<CaptureResult>> watchAllSorted() {
    return _resultBox.watch().map((_) => allSorted());
  }
}
