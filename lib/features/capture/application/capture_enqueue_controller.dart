import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/application/capture_queue_service.dart';

class CaptureEnqueueController extends StateNotifier<AsyncValue<CaptureJob?>> {
  CaptureEnqueueController(this._queueService) : super(const AsyncData(null));

  final CaptureQueueService _queueService;

  Future<void> enqueueImage(String imagePath) async {
    await _enqueue(() => _queueService.enqueueImagePath(imagePath));
  }

  Future<void> enqueueBarcode(String barcode) async {
    await _enqueue(() => _queueService.enqueueBarcode(barcode));
  }

  Future<void> _enqueue(Future<CaptureJob> Function() action) async {
    state = const AsyncLoading();
    try {
      final job = await action();
      state = AsyncData(job);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
