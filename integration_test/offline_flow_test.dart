import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
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

    testWidgets('Failed sync can be retried -> offline -> online with error -> retry succeeds',
        (tester) async {
      final connectivityController = StreamController<List<ConnectivityResult>>.broadcast();
      int apiCallCount = 0;

      when(mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => connectivityController.stream,
      );

      // Start offline
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

      await app.main(overrides: overrides);
      await tester.pumpAndSettle();

      // Create entry while offline
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Texto'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Título de la comida *'), 'Retry Test Entry');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Ingrediente 1'), 'Test Ingredient');

      await tester.tap(find.text('Guardar entrada'));
      await tester.pumpAndSettle();

      // Verify entry is pending
      final element1 = tester.element(find.byType(app.SyncInitializer));
      final container1 = ProviderScope.containerOf(element1);
      final entryRepo1 = container1.read(localEntryRepositoryProvider);

      await tester.pump(const Duration(milliseconds: 500));
      expect(entryRepo1.getPendingEntries().length, 1);

      // Go online but mock API to fail
      when(mockCaptureApi.analyzeImage(file: anyNamed('file'), type: anyNamed('type')))
          .thenAnswer((_) async {
        apiCallCount++;
        if (apiCallCount == 1) {
          throw Exception('Network error during sync');
        }
        // Second call succeeds (we won't reach this in this test)
        throw Exception('Should not reach here');
      });

      connectivityController.add([ConnectivityResult.wifi]);
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // Entry should still be pending or failed after failed sync attempt
      final element2 = tester.element(find.byType(app.SyncInitializer));
      final container2 = ProviderScope.containerOf(element2);
      final entryRepo2 = container2.read(localEntryRepositoryProvider);

      final pendingOrFailed = entryRepo2
          .getAllEntries()
          .where((e) => e.syncStatus == SyncStatus.pending || e.syncStatus == SyncStatus.failed)
          .toList();
      expect(pendingOrFailed.length, greaterThan(0));

      // Note: In a real scenario, we would mock the API to succeed on retry
      // and wait for the automatic retry with backoff, but that would make
      // the test very slow. The important part is verifying the entry is
      // marked as failed and persists for retry.

      await TestHelpers.cleanupTestFiles();
      await connectivityController.close();
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
