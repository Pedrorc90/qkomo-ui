import 'package:meta/meta.dart';

import '../data/capture_queue_repository.dart';
import '../data/capture_result_repository.dart';
import '../domain/capture_analyzer.dart';
import '../domain/capture_job.dart';

/// Processes pending capture jobs and persists their results offline.
class CaptureQueueProcessor {
  CaptureQueueProcessor({
    required CaptureQueueRepository queueRepository,
    required CaptureResultRepository resultRepository,
    required CaptureAnalyzer analyzer,
    Duration? successTtl,
  })  : _queueRepository = queueRepository,
        _resultRepository = resultRepository,
        _analyzer = analyzer,
        _successTtl = successTtl ?? const Duration(days: 7);

  final CaptureQueueRepository _queueRepository;
  final CaptureResultRepository _resultRepository;
  final CaptureAnalyzer _analyzer;
  final Duration _successTtl;

  bool _isProcessing = false;

  @visibleForTesting
  bool get isProcessing => _isProcessing;

  /// Processes all pending jobs. Returns how many succeeded.
  Future<int> processPending() async {
    if (_isProcessing) return 0;
    _isProcessing = true;

    try {
      final pending = _queueRepository.pendingJobs();
      var succeeded = 0;

      for (final job in pending) {
        await _queueRepository.markProcessing(job.id);
        final isSuccess = await _handleJob(job);
        if (isSuccess) {
          succeeded++;
        }
      }

      await _queueRepository.clearSucceeded(olderThan: _successTtl);
      return succeeded;
    } finally {
      _isProcessing = false;
    }
  }

  Future<bool> _handleJob(CaptureJob job) async {
    try {
      final result = await _analyzer.analyze(job);
      await _resultRepository.saveResult(result);
      await _queueRepository.markSuccess(job.id);
      return true;
    } catch (e) {
      await _queueRepository.markFailure(job.id, e.toString());
      return false;
    }
  }
}
