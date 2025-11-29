import 'package:hive/hive.dart';

import '../domain/capture_result.dart';

class CaptureResultRepository {
  CaptureResultRepository({required Box<CaptureResult> resultBox})
      : _resultBox = resultBox;

  final Box<CaptureResult> _resultBox;

  Future<void> saveResult(CaptureResult result) async {
    await _resultBox.put(result.jobId, result);
  }

  CaptureResult? findByJobId(String jobId) {
    return _resultBox.get(jobId);
  }

  List<CaptureResult> allSorted() {
    final items = _resultBox.values.toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  List<CaptureResult> today() {
    final now = DateTime.now();
    return _resultBox.values.where((result) {
      final saved = result.savedAt;
      return saved.year == now.year &&
          saved.month == now.month &&
          saved.day == now.day;
    }).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }
}
