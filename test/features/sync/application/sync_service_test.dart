import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/sync/application/sync_service.dart';

import 'sync_service_test.mocks.dart';

@GenerateMocks([HybridEntryRepository, Connectivity])
void main() {
  late MockHybridEntryRepository mockRepo;
  late MockConnectivity mockConnectivity;
  late SyncService service;

  setUp(() {
    mockRepo = MockHybridEntryRepository();
    mockConnectivity = MockConnectivity();

    // Stub the connectivity stream
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));

    service = SyncService(
      repository: mockRepo,
      connectivity: mockConnectivity,
    );
  });

  test('sync should call repository sync when cloud sync enabled', () async {
    // Basic test structure
    if (FeatureFlags.enableCloudSync) {
      await service.sync();
      verify(mockRepo.sync()).called(1);
    } else {
      await service.sync();
      verifyNever(mockRepo.sync());
    }
  });
}
