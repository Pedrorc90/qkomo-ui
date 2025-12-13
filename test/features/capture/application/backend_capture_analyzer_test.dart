import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';

class FakeCaptureApiClient implements CaptureApiClient {
  bool shouldThrow = false;
  AnalyzeResponseDto? successResponse;
  String? lastAnalyzedBarcode;
  XFile? lastAnalyzedImage;
  String? lastAnalysisType;

  @override
  // ignore: override_on_non_overriding_member
  Future<AnalyzeResponseDto> analyzeImage({required XFile file, String? type}) async {
    lastAnalyzedImage = file;
    lastAnalysisType = type;
    if (shouldThrow) throw Exception('Network error');
    return successResponse!;
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<AnalyzeResponseDto> analyzeBarcode(String barcode) async {
    lastAnalyzedBarcode = barcode;
    if (shouldThrow) throw Exception('Network error');
    return successResponse!;
  }

  // ignore: unused_field
  final dynamic _dio = null; // unused
}

void main() {
  late BackendCaptureAnalyzer analyzer;
  late FakeCaptureApiClient fakeApiClient;

  final validDto = AnalyzeResponseDto(
    analysisId: '1',
    type: 'meal',
    photoId: 'photo1',
    identification: IdentificationDto(
      dishName: 'Test Dish',
      detectedIngredients: ['Ing1'],
    ),
    nutrition: NutritionDto(),
    medicalAlerts: MedicalAlertsDto(),
    suitableFor: SuitableForDto(),
    allergens: [],
    improvementSuggestions: [],
  );

  setUp(() {
    fakeApiClient = FakeCaptureApiClient();
    analyzer = BackendCaptureAnalyzer(fakeApiClient);
  });

  group('BackendCaptureAnalyzer', () {
    test('analyze calls analyzeImage for camera mode', () async {
      fakeApiClient.successResponse = validDto;
      final file = XFile('/tmp/test.jpg');

      final result = await analyzer.analyze(
        mode: CaptureMode.camera,
        file: file,
      );

      expect(result.title, 'Test Dish');
      expect(fakeApiClient.lastAnalyzedImage?.path, '/tmp/test.jpg');
    });

    test('analyze calls analyzeBarcode for barcode mode', () async {
      fakeApiClient.successResponse = validDto;

      final result = await analyzer.analyze(
        mode: CaptureMode.barcode,
        barcode: '123456',
      );

      expect(result.title, 'Test Dish');
      expect(fakeApiClient.lastAnalyzedBarcode, '123456');
    });

    test('analyze throws exception when image file is missing for camera mode', () async {
      expect(
        () => analyzer.analyze(mode: CaptureMode.camera, file: null),
        throwsException,
      );
    });

    test('analyze propagates exception from api client', () async {
      fakeApiClient.shouldThrow = true;

      expect(
        () => analyzer.analyze(mode: CaptureMode.barcode, barcode: '123456'),
        throwsException,
      );
    });
  });
}
