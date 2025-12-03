import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

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

  List<CaptureResult> thisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return _resultBox.values.where((result) {
      return result.savedAt
          .isAfter(startDate.subtract(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  List<CaptureResult> thisMonth() {
    final now = DateTime.now();
    return _resultBox.values.where((result) {
      final saved = result.savedAt;
      return saved.year == now.year && saved.month == now.month;
    }).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  List<CaptureResult> byDateRange(DateTime start, DateTime end) {
    return _resultBox.values.where((result) {
      return result.savedAt.isAfter(start.subtract(const Duration(days: 1))) &&
          result.savedAt.isBefore(end.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Stream<List<CaptureResult>> watchAllSorted() {
    return _resultBox.watch().map((_) => allSorted());
  }
}
