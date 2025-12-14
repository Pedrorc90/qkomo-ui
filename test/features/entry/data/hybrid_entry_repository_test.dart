import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';

import 'hybrid_entry_repository_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<LocalEntryRepository>(), MockSpec<RemoteEntryRepository>()])
void main() {
  late HybridEntryRepository repository;
  late MockLocalEntryRepository mockLocalRepo;
  late MockRemoteEntryRepository mockRemoteRepo;

  setUp(() {
    mockLocalRepo = MockLocalEntryRepository();
    mockRemoteRepo = MockRemoteEntryRepository();
    repository = HybridEntryRepository(
      localRepo: mockLocalRepo,
      remoteRepo: mockRemoteRepo,
      enableCloudSync: true,
    );
  });

  const tEntryId = 'test-id';
  final tResult = CaptureResult(
    jobId: 'job-id',
    savedAt: DateTime(2023, 1, 1),
    title: 'Test Meal',
  );

  final tEntry = Entry(
    id: tEntryId,
    result: tResult,
    lastModifiedAt: DateTime(2023, 1, 1),
    syncStatus: SyncStatus.synced,
    lastSyncedAt: DateTime(2023, 1, 1),
  );

  group('sync', () {
    test('should fetch remote entries and save them locally if new', () async {
      // Arrange
      when(mockLocalRepo.getAllEntries()).thenReturn([]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenAnswer((_) async => [tEntry]);
      when(mockLocalRepo.getEntryById(tEntryId)).thenReturn(null);

      // Act
      await repository.sync();

      // Assert
      verify(mockRemoteRepo.fetchEntries(from: null)); // No previous sync time
      verify(mockLocalRepo.saveEntry(tEntry));
    });

    test('should detect conflict when local entry has pending changes',
        () async {
      // Arrange
      final tRemoteEntry = tEntry.copyWith(
        cloudVersion: 2,
        lastModifiedAt: DateTime(2023, 1, 2),
      );
      final tLocalEntry = tEntry.copyWith(
        syncStatus: SyncStatus.pending,
        lastModifiedAt: DateTime(2023, 1, 2), // Locally modified
      );

      when(mockLocalRepo.getAllEntries()).thenReturn([tLocalEntry]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenAnswer((_) async => [tRemoteEntry]);
      when(mockLocalRepo.getEntryById(tEntryId)).thenReturn(tLocalEntry);

      // Act
      await repository.sync();

      // Assert
      verify(mockLocalRepo.saveEntry(argThat(predicate<Entry>(
          (e) => e.syncStatus == SyncStatus.conflict && e.id == tEntryId))));
    });

    test('should overwrite local entry if synced/clean and remote is newer',
        () async {
      // Arrange
      final tRemoteEntry = tEntry.copyWith(cloudVersion: 2);
      final tLocalEntry = tEntry.copyWith(syncStatus: SyncStatus.synced);

      when(mockLocalRepo.getAllEntries()).thenReturn([tLocalEntry]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenAnswer((_) async => [tRemoteEntry]);
      when(mockLocalRepo.getEntryById(tEntryId)).thenReturn(tLocalEntry);

      // Act
      await repository.sync();

      // Assert
      verify(mockLocalRepo.saveEntry(tRemoteEntry));
    });

    test('should push pending entries after pulling', () async {
      // Arrange
      final tPendingEntry = tEntry.copyWith(syncStatus: SyncStatus.pending);
      when(mockLocalRepo.getAllEntries()).thenReturn([]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenAnswer((_) async => []);
      when(mockLocalRepo.getPendingEntries()).thenReturn([tPendingEntry]);

      // Act
      await repository.sync();

      // Assert
      verify(mockRemoteRepo.pushEntry(tPendingEntry));
      verify(mockLocalRepo.saveEntry(
          argThat(predicate<Entry>((e) => e.syncStatus == SyncStatus.synced))));
    });
  });
}
