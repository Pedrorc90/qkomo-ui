import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/core/services/logger_service.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';

import 'hybrid_entry_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalEntryRepository>(),
  MockSpec<RemoteEntryRepository>(),
  MockSpec<LogService>()
])
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
    savedAt: DateTime(2023),
    title: 'Test Meal',
  );

  final tEntry = Entry(
    id: tEntryId,
    result: tResult,
    lastModifiedAt: DateTime(2023),
    syncStatus: SyncStatus.synced,
    lastSyncedAt: DateTime(2023),
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
      verify(mockRemoteRepo.fetchEntries()); // No previous sync time
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

    test('should continue push attempt even if pull fails', () async {
      // Arrange
      final tPendingEntry = tEntry.copyWith(syncStatus: SyncStatus.pending);
      when(mockLocalRepo.getAllEntries()).thenReturn([]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenThrow(Exception('Network error'));
      when(mockLocalRepo.getPendingEntries()).thenReturn([tPendingEntry]);
      when(mockRemoteRepo.pushEntry(tPendingEntry))
          .thenAnswer((_) async => {});

      // Act & Assert - sync() should throw, but pushEntry should have been called
      expect(
        () => repository.sync(),
        throwsException,
      );

      // Verify push was attempted despite pull failure
      verify(mockRemoteRepo.pushEntry(tPendingEntry));
    });

    test('should propagate pull error to caller after push attempt', () async {
      // Arrange
      final testException = Exception('Pull failed: Network error');
      when(mockLocalRepo.getAllEntries()).thenReturn([]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenThrow(testException);
      when(mockLocalRepo.getPendingEntries()).thenReturn([]);

      // Act & Assert
      expect(
        () => repository.sync(),
        throwsA(isA<Exception>()),
      );

      // Verify error was logged
      // Note: This would require passing LogService as dependency to verify,
      // but the logging is happening via singleton LogService().e()
    });

    test('should mark entry as failed when push fails', () async {
      // Arrange
      final tPendingEntry = tEntry.copyWith(syncStatus: SyncStatus.pending);
      when(mockLocalRepo.getAllEntries()).thenReturn([]);
      when(mockRemoteRepo.fetchEntries(from: anyNamed('from')))
          .thenAnswer((_) async => []);
      when(mockLocalRepo.getPendingEntries()).thenReturn([tPendingEntry]);
      when(mockRemoteRepo.pushEntry(tPendingEntry))
          .thenThrow(Exception('Push failed: Server error'));

      // Act
      await repository.sync();

      // Assert - entry should be marked as failed
      verify(mockLocalRepo.saveEntry(argThat(predicate<Entry>(
          (e) => e.syncStatus == SyncStatus.failed && e.id == tEntryId))));
    });
  });
}
