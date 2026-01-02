import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

/// UseCase: Get capture results for this month
///
/// Returns all results created this month, sorted by newest first.
class GetMonthResults {
  GetMonthResults(this._repository);

  final CaptureResultRepository _repository;

  List<CaptureResult> call() {
    final allResults = _repository.allSorted();

    final now = DateTime.now();

    return allResults.where((result) {
      final saved = result.savedAt;
      return saved.year == now.year && saved.month == now.month;
    }).toList();
  }
}
