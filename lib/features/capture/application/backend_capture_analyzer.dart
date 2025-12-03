import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/capture/domain/capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

/// Analyzer that calls the backend `/v1/analyze` and `/v1/analyze/barcode` endpoints.
class BackendCaptureAnalyzer implements CaptureAnalyzer {
  BackendCaptureAnalyzer(this._apiClient);

  final CaptureApiClient _apiClient;

  @override
  Future<CaptureResult> analyze(CaptureJob job, {XFile? file}) async {
    switch (job.type) {
      case CaptureJobType.image:
        final imageFile =
            file ?? (job.imagePath != null ? XFile(job.imagePath!) : null);

        if (imageFile == null) {
          throw Exception('Falta la ruta de la imagen para este trabajo.');
        }
        final response = await _apiClient.analyzeImage(
          file: imageFile,
          type: 'meal',
        );
        return _toResult(job, response);
      case CaptureJobType.barcode:
        if (job.barcode == null || job.barcode!.isEmpty) {
          throw Exception('Falta el código de barras para este trabajo.');
        }
        final response = await _apiClient.analyzeBarcode(job.barcode!);
        return _toResult(job, response);
    }
  }

  CaptureResult _toResult(CaptureJob job, AnalyzeResponseDto dto) {
    final ingredientNames = dto.ingredients.map((i) => i.name).toList();
    final allergens = dto.ingredients.expand((i) => i.allergens).toList();
    final notes = dto.warnings.isNotEmpty ? dto.warnings.join('\n') : null;
    final title = switch (job.type) {
      CaptureJobType.barcode => 'Producto código ${job.barcode}',
      CaptureJobType.image =>
        dto.photoId != null ? 'Foto ${dto.photoId}' : 'Captura ${job.id}',
    };

    return CaptureResult(
      jobId: job.id,
      savedAt: DateTime.now(),
      title: title,
      ingredients: ingredientNames,
      allergens: allergens,
      notes: notes,
    );
  }
}
