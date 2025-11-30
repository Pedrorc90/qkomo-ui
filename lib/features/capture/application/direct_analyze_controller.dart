import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';

class DirectAnalyzeController extends StateNotifier<AsyncValue<String?>> {
  DirectAnalyzeController(
    this._analyzer,
    this._resultRepository,
  ) : super(const AsyncValue.data(null));

  final BackendCaptureAnalyzer _analyzer;
  final CaptureResultRepository _resultRepository;
  final _uuid = const Uuid();

  Future<void> analyze(CaptureState captureState) async {
    print('analyze');
    state = const AsyncValue.loading();
    try {
      final jobId = _uuid.v4();
      late CaptureJob job;

      if (captureState.imageFile != null) {
        job = CaptureJob(
          id: jobId,
          type: CaptureJobType.image,
          imagePath: captureState.imageFile!.path,
          createdAt: DateTime.now(),
        );
      } else if (captureState.scannedBarcode != null) {
        job = CaptureJob(
          id: jobId,
          type: CaptureJobType.barcode,
          barcode: captureState.scannedBarcode,
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception('No hay imagen ni código para analizar');
      }

      final result = await _analyzer.analyze(
        job,
        file: captureState.imageFile,
      );

      await _resultRepository.saveResult(result);

      this.state = AsyncValue.data(result.jobId);
    } catch (e, st) {
      print('Error in analyze: $e');
      print(st);
      this.state = AsyncValue.error(e, st);
    }
  }
}
