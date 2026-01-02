import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

/// UseCase: Get capture results for this week
///
/// Returns all results created this week (from Monday to today),
/// sorted by newest first.
class GetWeekResults {
  GetWeekResults(this._repository);

  final CaptureResultRepository _repository;

  List<CaptureResult> call() {
    final allResults = _repository.allSorted();

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return allResults.where((result) {
      return result.savedAt.isAfter(startDate.subtract(const Duration(days: 1)));
    }).toList();
  }
}
