import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/capture/domain/capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

/// Analyzer that calls the backend `/v1/analyze` and `/v1/analyze/barcode` endpoints.
class BackendCaptureAnalyzer implements CaptureAnalyzer {
  BackendCaptureAnalyzer(this._apiClient);

  final CaptureApiClient _apiClient;

  @override
  Future<CaptureResult> analyze(CaptureJob job, {XFile? file}) async {
    switch (job.type) {
      case CaptureJobType.image:
        final imageFile = file ?? (job.imagePath != null ? XFile(job.imagePath!) : null);

        if (imageFile == null) {
          throw Exception('Falta la ruta de la imagen para este trabajo.');
        }
        final analysisType = _getAnalysisType(job.captureMode);
        final response = await _apiClient.analyzeImage(
          file: imageFile,
          type: analysisType,
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

  /// Maps CaptureMode to the analysis type string expected by the API
  String _getAnalysisType(CaptureMode? mode) {
    switch (mode) {
      case CaptureMode.camera:
        return 'photo';
      case CaptureMode.gallery:
        return 'gallery';
      case CaptureMode.barcode:
        return 'barcode';
      case CaptureMode.text:
      case null:
        return 'meal'; // Default fallback
    }
  }

  CaptureResult _toResult(CaptureJob job, AnalyzeResponseDto dto) {
    if (kDebugMode) {
      print('[BackendCaptureAnalyzer] Procesando respuesta del backend:');
      print('  - analysisId: ${dto.analysisId}');
      print('  - type: ${dto.type}');
      print('  - photoId: ${dto.photoId}');
      print('  - dishName: ${dto.identification.dishName}');
      print('  - ingredients: ${dto.identification.detectedIngredients}');
      print('  - allergens: ${dto.allergens}');
    }

    final title = dto.identification.dishName ??
        (switch (job.type) {
          CaptureJobType.barcode => 'Producto código ${job.barcode}',
          CaptureJobType.image => dto.photoId != null ? 'Foto ${dto.photoId}' : 'Captura ${job.id}',
        });

    final result = CaptureResult(
      jobId: job.id,
      savedAt: DateTime.now(),
      title: title,
      ingredients: dto.identification.detectedIngredients,
      allergens: dto.allergens,
      improvementSuggestions: dto.improvementSuggestions,
      estimatedPortionG: dto.identification.estimatedPortionG,
      nutrition: CaptureNutrition(
        calories: dto.nutrition.calories,
        proteinsG: dto.nutrition.proteinsG,
        carbohydratesG: dto.nutrition.carbohydratesG,
        fatsG: dto.nutrition.fatsG,
        fiberG: dto.nutrition.fiberG,
      ),
      medicalAlerts: CaptureMedicalAlerts(
        diabetes: dto.medicalAlerts.diabetes,
        hypertension: dto.medicalAlerts.hypertension,
        cholesterol: dto.medicalAlerts.cholesterol,
      ),
      suitableFor: CaptureSuitableFor(
        children: dto.suitableFor.children,
        lowFodmap: dto.suitableFor.lowFodmap,
        glutenFree: dto.suitableFor.glutenFree,
        vegetarian: dto.suitableFor.vegetarian,
        vegan: dto.suitableFor.vegan,
      ),
    );

    if (kDebugMode) {
      print('[BackendCaptureAnalyzer] CaptureResult creado:');
      print('  - title: ${result.title}');
      print('  - ingredients: ${result.ingredients}');
      print('  - allergens: ${result.allergens}');
    }

    return result;
  }
}
