import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';

/// UseCase: Save a capture result to storage
///
/// Persists a CaptureResult using the repository.
class SaveCaptureResult {
  SaveCaptureResult(this._repository);

  final CaptureResultRepository _repository;

  Future<void> call(CaptureResult result) async {
    await _repository.saveResult(result);
  }
}
