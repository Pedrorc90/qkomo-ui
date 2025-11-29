import '../data/capture_api_client.dart';
import '../data/models/analyze_response_dto.dart';
import '../domain/capture_analyzer.dart';
import '../domain/capture_job.dart';
import '../domain/capture_job_type.dart';
import '../domain/capture_result.dart';

/// Analyzer that calls the backend `/v1/analyze` and `/v1/analyze/barcode` endpoints.
class BackendCaptureAnalyzer implements CaptureAnalyzer {
  BackendCaptureAnalyzer(this._apiClient);

  final CaptureApiClient _apiClient;

  @override
  Future<CaptureResult> analyze(CaptureJob job) async {
    switch (job.type) {
      case CaptureJobType.image:
        if (job.imagePath == null) {
          throw Exception('Falta la ruta de la imagen para este trabajo.');
        }
        final response = await _apiClient.analyzeImage(
          path: job.imagePath!,
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
