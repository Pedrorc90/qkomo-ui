import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'capture_queue_processor.dart';

class CaptureQueueProcessController extends StateNotifier<AsyncValue<int>> {
  CaptureQueueProcessController(this._processor) : super(const AsyncData(0));

  final CaptureQueueProcessor _processor;

  Future<void> processPending() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final processed = await _processor.processPending();
      state = AsyncData(processed);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
