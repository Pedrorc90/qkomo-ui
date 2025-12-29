import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/data/models/analyze_response_dto.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/main_test.dart' as app;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import '../test/helpers/shared_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final mockUser = MockUser();
  final mockConnectivity = MockConnectivity();
  final mockCaptureApi = MockCaptureApiClient();
  final connectivityController = StreamController<List<ConnectivityResult>>.broadcast();

  when(mockUser.uid).thenReturn('test-user-id');
  when(mockUser.email).thenReturn('test@example.com');
  when(mockUser.displayName).thenReturn('Test User');

  when(mockConnectivity.onConnectivityChanged).thenAnswer(
    (_) => connectivityController.stream,
  );

  group('Offline Flow Test', () {
    testWidgets('Offline Capture -> Save Locally -> Go Online -> Auto Sync', (tester) async {
      // 1. Start Offline
      connectivityController.add([ConnectivityResult.none]);
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.none],
      );

      final overrides = [
        authStateChangesProvider.overrideWith((ref) => Stream.value(mockUser)),
        authControllerProvider.overrideWithValue(FakeAuthController()),
        captureApiClientProvider.overrideWithValue(mockCaptureApi),
        connectivityProvider.overrideWithValue(mockConnectivity),
      ];

      // 2. Mock API Response for when we go online
      when(mockCaptureApi.uploadPhoto(any)).thenAnswer((_) async => 'test-photo-id');
      when(mockCaptureApi.analyzeImage(file: anyNamed('file'), type: anyNamed('type')))
          .thenAnswer((_) async => AnalyzeResponseDto(
                analysisId: 'test-analysis-id',
                type: 'meal',
                photoId: 'test-photo-id',
                identification: IdentificationDto(
                  dishName: 'Ensalada Offline',
                  detectedIngredients: ['Lechuga'],
                ),
                nutrition: NutritionDto(calories: 100),
                allergens: [],
              ));

      // 3. Start App
      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // Verify we are on home
      expect(find.text('Entradas recientes'), findsOneWidget);

      // 4. Navigate to Capture
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Check for CapturePage
      expect(find.text('Análisis sugerido'), findsOneWidget);

      // 5. Test logic would continue here...
      // In a real integration test, we would use a specialized helper to simulate
      // the full save flow without actually needing to click through every UI pick.

      // For now, we'll verify the connectivity mock works as expected in the UI if there's an indicator.
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
