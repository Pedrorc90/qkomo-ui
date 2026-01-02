import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

/// UseCase: Get capture results for today
///
/// Returns all results created today, sorted by newest first.
class GetTodayResults {
  GetTodayResults(this._repository);

  final CaptureResultRepository _repository;

  List<CaptureResult> call() {
    final allResults = _repository.allSorted();

    final now = DateTime.now();

    return allResults.where((result) {
      final saved = result.savedAt;
      return saved.year == now.year &&
          saved.month == now.month &&
          saved.day == now.day;
    }).toList();
  }
}
