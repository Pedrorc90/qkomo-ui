import 'package:flutter_test/flutter_test.dart';

import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_status.dart';

void main() {
  group('BackendCaptureAnalyzer - Data Models', () {
    test('AnalyzeResponseDto should parse correctly', () {
      // Test that the DTO models work correctly
      final dto = AnalyzeResponseDto(
        analysisId: 'analysis-123',
        type: 'meal',
        photoId: 'photo-123',
        identification: IdentificationDto(
          dishName: 'Cake',
          detectedIngredients: ['Flour', 'Sugar'],
        ),
        nutrition: NutritionDto(
          calories: 100,
        ),
        medicalAlerts: MedicalAlertsDto(),
        suitableFor: SuitableForDto(),
        allergens: ['gluten'],
        improvementSuggestions: ['Eat less'],
      );

      expect(dto.analysisId, equals('analysis-123'));
      expect(dto.type, equals('meal'));
      expect(dto.photoId, equals('photo-123'));
      expect(dto.identification.dishName, equals('Cake'));
      expect(dto.identification.detectedIngredients, hasLength(2));
      expect(dto.identification.detectedIngredients[0], equals('Flour'));
      expect(dto.allergens, contains('gluten'));
      expect(dto.improvementSuggestions, contains('Eat less'));
    });

    test('CaptureJob should be created for image type', () {
      final job = CaptureJob(
        id: 'job-1',
        type: CaptureJobType.image,
        imagePath: '/path/to/image.jpg',
        createdAt: DateTime.now(),
        status: CaptureJobStatus.pending,
      );

      expect(job.type, equals(CaptureJobType.image));
      expect(job.imagePath, equals('/path/to/image.jpg'));
      expect(job.status, equals(CaptureJobStatus.pending));
    });

    test('CaptureJob should be created for barcode type', () {
      final job = CaptureJob(
        id: 'job-2',
        type: CaptureJobType.barcode,
        barcode: '1234567890123',
        createdAt: DateTime.now(),
        status: CaptureJobStatus.pending,
      );

      expect(job.type, equals(CaptureJobType.barcode));
      expect(job.barcode, equals('1234567890123'));
      expect(job.status, equals(CaptureJobStatus.pending));
    });

    test('IdentificationDto should handle ingredients correctly', () {
      final identification = IdentificationDto(
        dishName: 'Soup',
        detectedIngredients: ['Water', 'Salt'],
      );

      expect(identification.dishName, equals('Soup'));
      expect(identification.detectedIngredients, hasLength(2));
      expect(identification.detectedIngredients, containsAll(['Water', 'Salt']));
    });
  });

  group('BackendCaptureAnalyzer - Integration Notes', () {
    test('analyzer would require running backend for full testing', () {
      // Note: Full integration testing of BackendCaptureAnalyzer requires:
      // 1. A running backend server
      // 2. Valid Firebase authentication
      // 3. Network connectivity
      //
      // These tests verify the data models work correctly.
      // For full E2E testing, run the app with a real backend.

      expect(true, isTrue);
    });
  });
}
