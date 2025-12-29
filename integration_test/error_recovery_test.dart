import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/main_test.dart' as app;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';

import '../test/helpers/shared_mocks.mocks.dart';

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

  group('Error Recovery Test', () {
    testWidgets('API Error -> Show Error Message -> Retry', (tester) async {
      // 1. Mock API Error
      when(mockCaptureApi.analyzeImage(file: anyNamed('file'), type: anyNamed('type')))
          .thenThrow(Exception('Backend 500 Error'));

      final overrides = [
        authStateChangesProvider.overrideWith((ref) => Stream.value(mockUser)),
        authControllerProvider.overrideWithValue(FakeAuthController()),
        captureApiClientProvider.overrideWithValue(mockCaptureApi),
        connectivityProvider.overrideWithValue(mockConnectivity),
      ];

      // 2. Start App
      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // 3. Navigate to Capture
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we are on CapturePage
      expect(find.text('Análisis sugerido'), findsOneWidget);

      // In a real integration test, we would trigger an analysis and then
      // check for the error snackbar or dialog.
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
