import '../data/capture_queue_repository.dart';
import '../data/capture_result_repository.dart';
import '../domain/capture_job.dart';
import '../domain/capture_result.dart';

/// Handles offline queue operations for capture jobs and their results.
class CaptureQueueService {
  CaptureQueueService({
    required CaptureQueueRepository queueRepository,
    required CaptureResultRepository resultRepository,
  })  : _queueRepository = queueRepository,
        _resultRepository = resultRepository;

  final CaptureQueueRepository _queueRepository;
  final CaptureResultRepository _resultRepository;

  Future<CaptureJob> enqueueImagePath(String path) {
    return _queueRepository.enqueueImage(path);
  }

  Future<CaptureJob> enqueueBarcode(String barcode) {
    return _queueRepository.enqueueBarcode(barcode);
  }

  List<CaptureJob> pendingJobs() {
    return _queueRepository.pendingJobs();
  }

  Future<void> markProcessing(String id) {
    return _queueRepository.markProcessing(id);
  }

  Future<void> markSuccess(String id) {
    return _queueRepository.markSuccess(id);
  }

  Future<void> markFailure(String id, String error) {
    return _queueRepository.markFailure(id, error);
  }

  Future<void> saveResult(CaptureResult result) {
    return _resultRepository.saveResult(result);
  }
}
