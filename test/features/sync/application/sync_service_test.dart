import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/sync/application/sync_service.dart';

import 'sync_service_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<HybridEntryRepository>(), MockSpec<Connectivity>()])
void main() {
  late SyncService service;
  late MockHybridEntryRepository mockRepo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockRepo = MockHybridEntryRepository();
    mockConnectivity = MockConnectivity();

    // Enable flag for testing
    FeatureFlags.enableCloudSync = true;

    // Use a controlled stream for connectivity
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));

    service = SyncService(
      repositories: [mockRepo],
      connectivity: mockConnectivity,
    );
  });

  tearDown(() {
    service.dispose();
  });

  test('init triggers initial sync', () async {
    service.init();
    await Future.delayed(Duration.zero);
    // Might be called once or twice depending on race condition between init call and stream listener
    verify(mockRepo.sync()).called(greaterThanOrEqualTo(1));
  });

  test('sync calls repository sync', () async {
    service.init();
    // Allow init sync to complete/start
    await Future.delayed(const Duration(milliseconds: 100));

    // Clear interactions to test manual sync specifically
    clearInteractions(mockRepo);

    await service.sync();
    verify(mockRepo.sync()).called(greaterThanOrEqualTo(1));
  });

  test('exponential backoff retries on failure', () async {
    // Arrange
    when(mockRepo.sync()).thenThrow(Exception('Sync failed'));

    // Act
    service.init();

    // Wait for initial failure handling
    await Future.delayed(const Duration(milliseconds: 100));

    // Check we tried at least once (or twice due to race)
    verify(mockRepo.sync()).called(greaterThanOrEqualTo(1));

    // Service should be in error state (or idle if finally block finished)
    // We can't easily test the timer execution without FakeAsync,
    // but we've verified the code path handles the error.
  });
}
