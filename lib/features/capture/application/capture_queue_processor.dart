import 'package:meta/meta.dart';

import 'package:qkomo_ui/features/capture/data/capture_queue_repository.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/domain/capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/domain/capture_error_messages.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';

/// Processes pending capture jobs and persists their results offline.
class CaptureQueueProcessor {
  CaptureQueueProcessor({
    required CaptureQueueRepository queueRepository,
    required CaptureResultRepository resultRepository,
    required CaptureAnalyzer analyzer,
    Duration? successTtl,
    int? maxRetryAttempts,
  })  : _queueRepository = queueRepository,
        _resultRepository = resultRepository,
        _analyzer = analyzer,
        _successTtl = successTtl ?? const Duration(days: 7),
        _maxRetryAttempts = maxRetryAttempts ?? 3;

  final CaptureQueueRepository _queueRepository;
  final CaptureResultRepository _resultRepository;
  final CaptureAnalyzer _analyzer;
  final Duration _successTtl;
  final int _maxRetryAttempts;

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
        // Skip jobs that have exceeded max retry attempts
        if (job.attempts >= _maxRetryAttempts) {
          print(
              'Skipping job ${job.id} - exceeded max retry attempts ($_maxRetryAttempts)');
          continue;
        }

        // Apply exponential backoff delay if this is a retry
        if (job.attempts > 0) {
          final delay = _calculateBackoffDelay(job.attempts);
          print(
              'Retrying job ${job.id} (attempt ${job.attempts + 1}) after ${delay.inMilliseconds}ms delay');
          await Future.delayed(delay);
        }

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

  /// Calculate exponential backoff delay based on attempt count.
  /// Formula: min(2^attempts * 1000ms, 30000ms)
  Duration _calculateBackoffDelay(int attempts) {
    final delayMs = (1 << attempts) * 1000; // 2^attempts * 1000
    final cappedDelayMs = delayMs > 30000 ? 30000 : delayMs;
    return Duration(milliseconds: cappedDelayMs);
  }

  Future<bool> _handleJob(CaptureJob job) async {
    try {
      final result = await _analyzer.analyze(job);
      await _resultRepository.saveResult(result);
      await _queueRepository.markSuccess(job.id);
      return true;
    } catch (e) {
      // Convert error to user-friendly Spanish message
      final errorMessage = CaptureErrorMessages.fromException(e);

      // Check if this error is retryable
      final isRetryable = CaptureErrorMessages.isRetryable(e);
      print(
          'Job ${job.id} failed: $errorMessage (retryable: $isRetryable, attempts: ${job.attempts})');

      await _queueRepository.markFailure(job.id, errorMessage);
      return false;
    }
  }
}
