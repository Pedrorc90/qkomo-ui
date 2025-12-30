import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/main_test.dart' as app;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'test_helpers.dart';
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

      // 2. Start App
      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // Verify we are on home
      expect(find.text('Entradas recientes'), findsOneWidget);

      // 3. Navigate to Capture -> Text
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Texto'));
      await tester.pumpAndSettle();

      // 4. Enter data and save
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Título de la comida *'), 'Pollo con arroz');
      await tester.enterText(find.widgetWithText(TextFormField, 'Ingrediente 1'), 'Pollo, Arroz');
      await tester.tap(find.text('Guardar entrada'));
      await tester.pumpAndSettle();

      // 5. Verify it saved (Snackbar shows up)
      expect(find.textContaining('Entrada guardada'), findsOneWidget);

      // Check repo state - should be pending
      final element = tester.element(find.byType(app.SyncInitializer));
      final container = ProviderScope.containerOf(element);
      final entryRepo = container.read(localEntryRepositoryProvider);

      // We might need a small wait for the save processing
      await tester.pump(const Duration(milliseconds: 500));
      expect(entryRepo.getPendingEntries().length, 1);

      // 6. Go Online
      connectivityController.add([ConnectivityResult.wifi]);
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      // Trigger sync manually or wait for auto-sync
      // SyncService watches connectivity
      await tester.pumpAndSettle();

      // 7. Verify auto-sync (wait for sync service to process)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final pendingCount = entryRepo.getPendingEntries().length;
      expect(pendingCount, 0, reason: 'All entries should be synced after going online');

      await TestHelpers.cleanupTestFiles();
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
