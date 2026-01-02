import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

/// Parameters for date range query
class GetResultsByDateRangeParams {
  const GetResultsByDateRangeParams({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}

/// UseCase: Get capture results within a date range
///
/// Returns all results between start and end dates (inclusive),
/// sorted by newest first.
class GetResultsByDateRange {
  GetResultsByDateRange(this._repository);

  final CaptureResultRepository _repository;

  List<CaptureResult> call(GetResultsByDateRangeParams params) {
    final allResults = _repository.allSorted();

    return allResults.where((result) {
      return result.savedAt.isAfter(params.start.subtract(const Duration(days: 1))) &&
          result.savedAt.isBefore(params.end.add(const Duration(days: 1)));
    }).toList();
  }
}
