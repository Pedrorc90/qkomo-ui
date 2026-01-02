import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

/// UseCase: Get all capture results sorted by date
///
/// Returns all results sorted by newest first.
class GetAllResultsSorted {
  GetAllResultsSorted(this._repository);

  final CaptureResultRepository _repository;

  List<CaptureResult> call() {
    return _repository.allSorted();
  }
}
