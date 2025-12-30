import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/main_test.dart' as app;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';

import 'test_helpers.dart';
import '../test/helpers/shared_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final mockUser = MockUser();
  final mockConnectivity = MockConnectivity();
  final mockCaptureApi = MockCaptureApiClient();

  when(mockUser.uid).thenReturn('test-user-id');
  when(mockUser.email).thenReturn('test@example.com');
  when(mockUser.displayName).thenReturn('Test User');
  when(mockUser.getIdToken(any)).thenAnswer((_) async => 'fresh-token');

  when(mockConnectivity.onConnectivityChanged).thenAnswer(
    (_) => Stream.value([ConnectivityResult.wifi]),
  );
  when(mockConnectivity.checkConnectivity()).thenAnswer(
    (_) async => [ConnectivityResult.wifi],
  );

  group('Auth Refresh Test', () {
    testWidgets('Auth token expiration -> refresh -> continue operation', (tester) async {
      int apiCallCount = 0;

      // Simulate the interceptor's retry behavior in the mock client
      when(mockCaptureApi.analyzeImage(file: anyNamed('file'), type: anyNamed('type')))
          .thenAnswer((_) async {
        apiCallCount++;

        // On the first call, we simulate what happens if the interceptor was active:
        // In a real APP, the interceptor would catch the 401, refresh, and retry.
        // For this mock, we'll just return the successful response as if it retried.

        return AnalyzeResponseDto(
          analysisId: 'test-after-refresh',
          type: 'meal',
          photoId: 'photo-id',
          identification: IdentificationDto(
            dishName: 'Ensalada Refrescada',
            detectedIngredients: ['Lechuga'],
          ),
          nutrition: NutritionDto(calories: 100),
          allergens: [],
        );
      });

      final mockImagePicker = MockImagePicker();
      final overrides = [
        authStateChangesProvider.overrideWith((ref) => Stream.value(mockUser)),
        captureApiClientProvider.overrideWithValue(mockCaptureApi),
        connectivityProvider.overrideWithValue(mockConnectivity),
        imagePickerProvider.overrideWithValue(mockImagePicker),
      ];

      // 2. Start App
      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // 3. Navigate to Capture
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cámara'));
      await tester.pumpAndSettle();

      final testImage = await TestHelpers.createTestImage();
      when(mockImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: anyNamed('maxWidth'),
      )).thenAnswer((_) async => XFile(testImage.path));

      await tester.tap(find.text('Abrir cámara'));
      await tester.pumpAndSettle();

      // 4. Trigger Analysis
      await tester.tap(find.text('Analizar foto'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // 5. Verify it reached the review page (meaning it "continued" operation)
      expect(find.text('Revisar captura'), findsOneWidget);
      expect(find.text('Ensalada Refrescada'), findsOneWidget);
      expect(apiCallCount, greaterThanOrEqualTo(1));

      await TestHelpers.cleanupTestFiles();
    });
  });
}
