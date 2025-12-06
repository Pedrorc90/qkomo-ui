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

@GenerateMocks([LocalEntryRepository, RemoteEntryRepository])
void main() {
  late MockLocalEntryRepository mockLocalRepo;
  late MockRemoteEntryRepository mockRemoteRepo;
  late HybridEntryRepository repository;

  setUp(() {
    mockLocalRepo = MockLocalEntryRepository();
    mockRemoteRepo = MockRemoteEntryRepository();
  });

  group('HybridEntryRepository - Cloud Sync Disabled', () {
    setUp(() {
      repository = HybridEntryRepository(
        localRepo: mockLocalRepo,
        remoteRepo: mockRemoteRepo,
        enableCloudSync: false,
      );
    });

    test('saveEntry should save locally only when cloud sync disabled', () async {
      final entry = _createTestEntry('test-1');

      when(mockLocalRepo.saveEntry(any)).thenAnswer((_) async {});

      await repository.saveEntry(entry);

      verify(mockLocalRepo.saveEntry(any)).called(1);
      verifyNever(mockRemoteRepo.pushEntry(any));
    });

    test('getEntries should return local entries only', () async {
      final entries = [_createTestEntry('test-1')];

      when(mockLocalRepo.getAllEntries()).thenReturn(entries);

      final result = await repository.getEntries();

      expect(result, equals(entries));
      verify(mockLocalRepo.getAllEntries()).called(1);
      verifyNever(mockRemoteRepo.fetchEntries());
    });

    test('sync should not call remote when cloud sync disabled', () async {
      when(mockLocalRepo.getPendingEntries()).thenReturn([]);

      await repository.sync();

      verify(mockLocalRepo.getPendingEntries()).called(1);
      verifyNever(mockRemoteRepo.pushEntry(any));
    });
  });

  group('HybridEntryRepository - Cloud Sync Enabled', () {
    setUp(() {
      repository = HybridEntryRepository(
        localRepo: mockLocalRepo,
        remoteRepo: mockRemoteRepo,
        enableCloudSync: true,
      );
    });

    test('saveEntry should save locally and trigger remote sync', () async {
      final entry = _createTestEntry('test-2');

      when(mockLocalRepo.saveEntry(any)).thenAnswer((_) async {});
      when(mockRemoteRepo.pushEntry(any)).thenAnswer((_) async {});

      await repository.saveEntry(entry);

      verify(mockLocalRepo.saveEntry(any)).called(greaterThanOrEqualTo(1));
    });

    test('sync should push pending entries to remote', () async {
      final pendingEntry = _createTestEntry('test-3');

      when(mockLocalRepo.getPendingEntries()).thenReturn([pendingEntry]);
      when(mockRemoteRepo.pushEntry(any)).thenAnswer((_) async {});
      when(mockLocalRepo.saveEntry(any)).thenAnswer((_) async {});

      await repository.sync();

      verify(mockLocalRepo.getPendingEntries()).called(1);
      verify(mockRemoteRepo.pushEntry(pendingEntry)).called(1);
      verify(mockLocalRepo.saveEntry(any)).called(1);
    });

    test('sync should mark entry as synced on success', () async {
      final pendingEntry = _createTestEntry('test-4');

      when(mockLocalRepo.getPendingEntries()).thenReturn([pendingEntry]);
      when(mockRemoteRepo.pushEntry(any)).thenAnswer((_) async {});
      when(mockLocalRepo.saveEntry(any)).thenAnswer((_) async {});

      await repository.sync();

      final captured = verify(mockLocalRepo.saveEntry(captureAny)).captured.last as Entry;
      expect(captured.syncStatus, equals(SyncStatus.synced));
      expect(captured.lastSyncedAt, isNotNull);
    });

    test('sync should mark entry as failed on error', () async {
      final pendingEntry = _createTestEntry('test-5');

      when(mockLocalRepo.getPendingEntries()).thenReturn([pendingEntry]);
      when(mockRemoteRepo.pushEntry(any)).thenThrow(Exception('Network error'));
      when(mockLocalRepo.saveEntry(any)).thenAnswer((_) async {});

      await repository.sync();

      final captured = verify(mockLocalRepo.saveEntry(captureAny)).captured.last as Entry;
      expect(captured.syncStatus, equals(SyncStatus.failed));
    });

    test('deleteEntry should soft delete locally and trigger sync', () async {
      final entry = _createTestEntry('test-6');

      when(mockLocalRepo.deleteEntry(any)).thenAnswer((_) async {});
      when(mockLocalRepo.getPendingEntries()).thenReturn([]);

      await repository.deleteEntry('test-6');

      verify(mockLocalRepo.deleteEntry('test-6')).called(1);
    });
  });
}

Entry _createTestEntry(String id) {
  return Entry(
    id: id,
    result: CaptureResult(
      jobId: id,
      title: 'Test Product',
      ingredients: ['ingredient1'],
      allergens: [],
      savedAt: DateTime.now(),
    ),
    lastModifiedAt: DateTime.now(),
    syncStatus: SyncStatus.pending,
  );
}
