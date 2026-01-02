import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/interfaces/capture_analyzer.dart';

/// Analyzer that calls the backend `/v1/analyze` and `/v1/analyze/barcode` endpoints.
class BackendCaptureAnalyzer implements CaptureAnalyzer {
  BackendCaptureAnalyzer(this._apiClient);

  final CaptureApiClient _apiClient;

  @override
  Future<CaptureResult> analyze({
    required CaptureMode mode,
    XFile? file,
    String? barcode,
  }) async {
    final jobId = (switch (mode) {
      CaptureMode.barcode => barcode ?? 'unknown',
      _ => file?.name ?? 'unknown',
    });

    if (mode == CaptureMode.barcode) {
      if (barcode == null || barcode.isEmpty) {
        throw Exception('Falta el código de barras.');
      }
      final response = await _apiClient.analyzeBarcode(barcode);
      return _toResult(jobId, mode, response, barcode: barcode);
    } else {
      // Photo or Gallery
      if (file == null) {
        throw Exception('Falta la imagen para el análisis.');
      }
      final analysisType = _getAnalysisType(mode);
      final response = await _apiClient.analyzeImage(
        file: file,
        type: analysisType,
      );
      return _toResult(jobId, mode, response, file: file);
    }
  }

  /// Maps CaptureMode to the analysis type string expected by the API
  String _getAnalysisType(CaptureMode mode) {
    switch (mode) {
      case CaptureMode.camera:
        return 'photo';
      case CaptureMode.gallery:
        return 'gallery';
      case CaptureMode.barcode:
        return 'barcode';
      case CaptureMode.text:
        return 'meal'; // Default fallback
    }
  }

  CaptureResult _toResult(
    String jobId,
    CaptureMode mode,
    AnalyzeResponseDto dto, {
    XFile? file,
    String? barcode,
  }) {
    if (kDebugMode) {
      print('[BackendCaptureAnalyzer] Processing backend response:');
      print('  - analysisId: ${dto.analysisId}');
      print('  - type: ${dto.type}');
      print('  - photoId: ${dto.photoId}');
      print('  - dishName: ${dto.identification.dishName}');
      print('  - ingredients: ${dto.identification.detectedIngredients}');
      print('  - allergens: ${dto.allergens}');
    }

    final title = dto.identification.dishName ??
        (switch (mode) {
          CaptureMode.barcode => 'Producto código $barcode',
          CaptureMode.camera => dto.photoId != null ? 'Foto ${dto.photoId}' : 'Captura',
          CaptureMode.gallery => 'Imagen importada',
          CaptureMode.text => 'Texto manual',
        });

    final imagePath = file?.path;

    if (kDebugMode) {
      print('[BackendCaptureAnalyzer] Image information:');
      print('  - file != null: ${file != null}');
      print('  - file?.path: ${file?.path}');
      print('  - imagePath: $imagePath');
    }

    final result = CaptureResult(
      jobId: dto.analysisId ?? jobId, // Use backend ID if available, else local
      savedAt: DateTime.now(),
      title: title,
      ingredients: dto.identification.detectedIngredients,
      allergens: dto.allergens,
      estimatedPortionG: dto.identification.estimatedPortionG,
      nutrition: CaptureNutrition(
        calories: dto.nutrition.calories,
        proteinsG: dto.nutrition.proteinsG,
        carbohydratesG: dto.nutrition.carbohydratesG,
        fatsG: dto.nutrition.fatsG,
        fiberG: dto.nutrition.fiberG,
      ),
      imagePath: imagePath,
    );

    if (kDebugMode) {
      print('[BackendCaptureAnalyzer] CaptureResult created:');
      print('  - jobId: ${result.jobId}');
      print('  - title: ${result.title}');
      print('  - imagePath: ${result.imagePath}');
      print('  - ingredients: ${result.ingredients}');
      print('  - allergens: ${result.allergens}');
    }

    return result;
  }
}
