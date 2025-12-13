import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:qkomo_ui/core/services/logger_service.dart';
import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';

class DirectAnalyzeController extends StateNotifier<AsyncValue<String?>> {
  DirectAnalyzeController(
    this._analyzer,
    this._resultRepository,
  ) : super(const AsyncValue.data(null));

  final BackendCaptureAnalyzer _analyzer;
  final CaptureResultRepository _resultRepository;
  final _uuid = const Uuid();
  final _logger = LogService();

  Future<void> analyze(CaptureState captureState) async {
    _logger.d('analyze');
    state = const AsyncValue.loading();
    try {
      if (captureState.mode == null) {
        throw Exception('Modo de captura no seleccionado');
      }

      final result = await _analyzer.analyze(
        mode: captureState.mode!,
        file: captureState.imageFile,
        barcode: captureState.scannedBarcode,
      );

      await _resultRepository.saveResult(result);

      state = AsyncValue.data(result.jobId);
    } catch (e, st) {
      _logger.e('Error in analyze', e, st);
      state = AsyncValue.error(e, st);
    }
  }
}
