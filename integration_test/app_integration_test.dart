import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/main_test.dart' as app;

import '../test/helpers/shared_mocks.mocks.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final mockUser = MockUser();
  final mockConnectivity = MockConnectivity();
  final mockCaptureApi = MockCaptureApiClient();

  when(mockUser.uid).thenReturn('test-user-id');
  when(mockUser.email).thenReturn('test@example.com');
  when(mockUser.displayName).thenReturn('Test User');

  when(mockConnectivity.onConnectivityChanged).thenAnswer(
    (_) => Stream.value([ConnectivityResult.wifi]),
  );
  when(mockConnectivity.checkConnectivity()).thenAnswer(
    (_) async => [ConnectivityResult.wifi],
  );

  group('End-to-end Smoke Test', () {
    testWidgets('Sign in -> Capture -> Analyze -> Save', (tester) async {
      // 1. Setup overrides
      final mockImagePicker = MockImagePicker();
      final overrides = [
        // Mock Auth to be already signed in
        authStateChangesProvider.overrideWith((ref) => Stream.value(mockUser)),
        authControllerProvider.overrideWithValue(FakeAuthController()),
        captureApiClientProvider.overrideWithValue(mockCaptureApi),
        connectivityProvider.overrideWithValue(mockConnectivity),
        imagePickerProvider.overrideWithValue(mockImagePicker),
      ];

      // 2. Mock API Response
      when(mockCaptureApi.analyzeImage(file: anyNamed('file'), type: anyNamed('type')))
          .thenAnswer((_) async => AnalyzeResponseDto(
                analysisId: 'test-analysis-id',
                type: 'meal',
                photoId: 'test-photo-id',
                identification: IdentificationDto(
                  dishName: 'Ensalada Test',
                  detectedIngredients: ['Lechuga', 'Tomate'],
                ),
                nutrition: NutritionDto(calories: 150),
                allergens: [],
              ));

      // 3. Start App
      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // Check if we are on the Home page
      expect(find.text('Entradas recientes'), findsOneWidget);

      // 4. Navigate to Capture
      final captureFab = find.byType(FloatingActionButton);
      expect(captureFab, findsOneWidget);
      await tester.tap(captureFab);
      await tester.pumpAndSettle();

      // We should be on CaptureBottomSheet.
      expect(find.text('¿Cómo quieres registrar tu comida?'), findsOneWidget);

      // 5. Select Camera mode
      await tester.tap(find.text('Cámara'));
      await tester.pumpAndSettle();

      // 6. Simulate picking an image
      final testImage = await TestHelpers.createTestImage();
      when(mockImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: anyNamed('maxWidth'),
      )).thenAnswer((_) async => XFile(testImage.path));

      await tester.tap(find.text('Abrir cámara'));
      await tester.pumpAndSettle();

      // Verify image is "loaded"
      expect(find.text('Foto lista para analizar'), findsOneWidget);

      // 7. Trigger Analysis
      await tester.tap(find.text('Analizar foto'));
      // Wait for analysis and navigation to review page
      await tester.pump(); // Start loading
      await tester.pump(const Duration(seconds: 1)); // Wait for timer in controller
      await tester.pumpAndSettle();

      // 8. Verify we are on CaptureReviewPage
      expect(find.text('Revisar captura'), findsOneWidget);
      expect(find.text('Ensalada Test'), findsOneWidget);

      // 9. Save analysis
      await tester.tap(find.text('Guardar análisis'));
      await tester.pumpAndSettle();

      // Wait for success feedback and navigation back
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // 10. Verify we are back on Home
      expect(find.text('Entradas recientes'), findsOneWidget);

      await TestHelpers.cleanupTestFiles();
    });

    testWidgets('Sign in -> Scan Barcode -> Analyze -> Save', (tester) async {
      // 1. Setup overrides
      final mockImagePicker = MockImagePicker();
      final overrides = [
        authStateChangesProvider.overrideWith((ref) => Stream.value(mockUser)),
        authControllerProvider.overrideWithValue(FakeAuthController()),
        captureApiClientProvider.overrideWithValue(mockCaptureApi),
        connectivityProvider.overrideWithValue(mockConnectivity),
        imagePickerProvider.overrideWithValue(mockImagePicker),
      ];

      // 2. Mock API Response
      when(mockCaptureApi.analyzeBarcode(any)).thenAnswer((_) async => AnalyzeResponseDto(
            analysisId: 'test-barcode-id',
            type: 'product',
            photoId: 'barcode-photo-id',
            identification: IdentificationDto(
              dishName: 'Producto Test',
              detectedIngredients: ['Ingrediente 1'],
            ),
            nutrition: NutritionDto(calories: 100),
            allergens: [],
          ));

      // 3. Start App
      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // 4. Navigate to Capture
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // 5. Select Barcode mode
      await tester.tap(find.text('Código QR'));
      await tester.pumpAndSettle();

      // 6. Simulate barcode scan
      // We need to trigger onBarcodeScanned manually if we can't easily simulate camera frames
      final container = ProviderScope.containerOf(tester.element(find.byType(app.SyncInitializer)));
      container.read(captureControllerProvider.notifier).onBarcodeScanned('1234567890123');
      await tester.pumpAndSettle();

      // 7. Trigger Analysis
      await tester.tap(find.text('Analizar código'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // 8. Verify Review Page
      expect(find.text('Revisar captura'), findsOneWidget);
      expect(find.text('Producto Test'), findsOneWidget);

      // 9. Save
      await tester.tap(find.text('Guardar análisis'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // 10. Verify back at Home
      expect(find.text('Entradas recientes'), findsOneWidget);
    });
  });
}

class FakeAuthController implements AuthController {
  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> signInWithApple() async {}
  @override
  Future<void> signInWithEmail(String email, String password, {bool register = false}) async {}
  @override
  Future<void> signOut() async {}
  @override
  Future<void> refreshIdToken() async {}
}
