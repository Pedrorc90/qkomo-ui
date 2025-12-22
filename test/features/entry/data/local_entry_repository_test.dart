import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';

void main() {
  late Box<Entry> entryBox;
  late LocalEntryRepository repository;

  setUp(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(EntryAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }

    // Open a test box
    entryBox = await Hive.openBox<Entry>('test_entries');
    repository = LocalEntryRepository(entryBox: entryBox);
  });

  tearDown(() async {
    await entryBox.clear();
    await entryBox.close();
    await Hive.deleteBoxFromDisk('test_entries');
  });

  group('LocalEntryRepository', () {
    test('saveEntry should save entry to Hive box', () async {
      final entry = _createTestEntry('test-1');

      await repository.saveEntry(entry);

      final saved = repository.getEntryById('test-1');
      expect(saved, isNotNull);
      expect(saved!.id, equals('test-1'));
      expect(saved.syncStatus, equals(SyncStatus.pending));
    });

    test('getEntryById should return null for non-existent entry', () {
      final entry = repository.getEntryById('non-existent');
      expect(entry, isNull);
    });

    test('deleteEntry should soft delete entry', () async {
      final entry = _createTestEntry('test-2');
      await repository.saveEntry(entry);

      await repository.deleteEntry('test-2');

      final deleted = repository.getEntryById('test-2');
      expect(deleted, isNotNull);
      expect(deleted!.isDeleted, isTrue);
      expect(deleted.syncStatus, equals(SyncStatus.pending));
    });

    test('getAllEntries should exclude deleted entries', () async {
      final entry1 = _createTestEntry('test-3');
      final entry2 = _createTestEntry('test-4');
      await repository.saveEntry(entry1);
      await repository.saveEntry(entry2);
      await repository.deleteEntry('test-3');

      final entries = repository.getAllEntries();

      expect(entries.length, equals(1));
      expect(entries.first.id, equals('test-4'));
    });

    test('getPendingEntries should return only pending entries', () async {
      final pending = _createTestEntry('test-5');
      final synced = _createTestEntry('test-6').copyWith(
        syncStatus: SyncStatus.synced,
      );
      await repository.saveEntry(pending);
      await repository.saveEntry(synced);

      final pendingEntries = repository.getPendingEntries();

      expect(pendingEntries.length, equals(1));
      expect(pendingEntries.first.id, equals('test-5'));
    });

    test('watchEntries should emit updates when entries change', () async {
      final stream = repository.watchEntries();

      // Expect initial empty list
      await expectLater(
        stream,
        emitsInOrder([
          [], // Initial state
          hasLength(1), // After adding entry
        ]),
      );

      await Future.delayed(const Duration(milliseconds: 100));
      await repository.saveEntry(_createTestEntry('test-7'));
    });
  });
}

Entry _createTestEntry(String id) {
  return Entry(
    id: id,
    result: CaptureResult(
      jobId: id,
      title: 'Test Product',
      ingredients: ['ingredient1', 'ingredient2'],
      allergens: ['allergen1'],
      savedAt: DateTime.now(),
    ),
    lastModifiedAt: DateTime.now(),
  );
}
