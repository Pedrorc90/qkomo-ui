import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/features/capture/domain/interfaces/capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// Local mock analyzer used offline until backend wiring (M4) is in place.
class MockCaptureAnalyzer implements CaptureAnalyzer {
  const MockCaptureAnalyzer();

  @override
  Future<CaptureResult> analyze({
    required CaptureMode mode,
    XFile? file,
    String? barcode,
  }) async {
    // Simulate minimal processing delay.
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final jobId = (switch (mode) {
      CaptureMode.barcode => barcode ?? 'unknown',
      _ => file?.name ?? 'unknown',
    });

    return CaptureResult(
      jobId: jobId,
      savedAt: DateTime.now(),
      title: _titleFor(mode, barcode, jobId),
      ingredients: _ingredientsFor(mode, barcode),
      notes: 'Resultado generado offline (mock).',
    );
  }

  String _titleFor(CaptureMode mode, String? barcode, String id) {
    if (mode == CaptureMode.barcode) {
      return 'Producto código ${barcode ?? '?'}';
    }
    return 'Captura ${id.substring(0, id.length > 6 ? 6 : id.length)}';
  }

  List<String> _ingredientsFor(CaptureMode mode, String? barcode) {
    if (mode == CaptureMode.barcode) {
      return [
        'Código: ${barcode ?? '?'}',
        'Consulta pendiente de backend',
      ];
    }
    return [
      'Imagen procesada',
      'Ingredientes generados offline',
    ];
  }
}
