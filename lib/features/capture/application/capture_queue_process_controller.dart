import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/capture_queue_repository.dart';
import 'capture_queue_processor.dart';

class CaptureQueueProcessController extends StateNotifier<AsyncValue<int>> {
  CaptureQueueProcessController(this._processor, this._queueRepository) : super(const AsyncData(0));

  final CaptureQueueProcessor _processor;
  final CaptureQueueRepository _queueRepository;

  Future<void> processPending() async {
    print('Starting processing of pending capture jobs');
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final processed = await _processor.processPending();
      state = AsyncData(processed);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Retry a specific failed job by resetting it to pending and processing
  Future<void> retryJob(String jobId) async {
    print('Retrying job $jobId');
    try {
      await _queueRepository.retryJob(jobId);
      // Process the queue to handle the retried job
      await processPending();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Retry all failed jobs by resetting them to pending and processing
  Future<void> retryAllFailed() async {
    print('Retrying all failed jobs');
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final failedJobs = _queueRepository.failedJobs();
      for (final job in failedJobs) {
        await _queueRepository.retryJob(job.id);
      }
      // Process the queue to handle all retried jobs
      final processed = await _processor.processPending();
      state = AsyncData(processed);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
