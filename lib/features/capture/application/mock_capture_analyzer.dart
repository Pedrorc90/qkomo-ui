import 'package:image_picker/image_picker.dart';

import '../domain/capture_analyzer.dart';
import '../domain/capture_job.dart';
import '../domain/capture_job_type.dart';
import '../domain/capture_result.dart';

/// Local mock analyzer used offline until backend wiring (M4) is in place.
class MockCaptureAnalyzer implements CaptureAnalyzer {
  const MockCaptureAnalyzer();

  @override
  Future<CaptureResult> analyze(CaptureJob job, {XFile? file}) async {
    // Simulate minimal processing delay.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return CaptureResult(
      jobId: job.id,
      savedAt: DateTime.now(),
      title: _titleFor(job),
      ingredients: _ingredientsFor(job),
      allergens: const [],
      notes: 'Resultado generado offline (mock).',
    );
  }

  String _titleFor(CaptureJob job) {
    if (job.type == CaptureJobType.barcode && job.barcode != null) {
      return 'Producto código ${job.barcode}';
    }
    return 'Captura ${job.id.substring(0, 6)}';
  }

  List<String> _ingredientsFor(CaptureJob job) {
    if (job.type == CaptureJobType.barcode && job.barcode != null) {
      return [
        'Código: ${job.barcode}',
        'Consulta pendiente de backend',
      ];
    }
    return [
      'Imagen en ${job.imagePath ?? 'archivo'}',
      'Ingredientes generados offline',
    ];
  }
}
