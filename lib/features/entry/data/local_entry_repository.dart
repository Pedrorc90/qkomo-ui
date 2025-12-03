import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';

class LocalEntryRepository {
  LocalEntryRepository({required Box<Entry> entryBox}) : _entryBox = entryBox;

  final Box<Entry> _entryBox;

  Future<void> saveEntry(Entry entry) async {
    await _entryBox.put(entry.id, entry);
  }

  Entry? getEntryById(String id) {
    return _entryBox.get(id);
  }

  Future<void> deleteEntry(String id) async {
    final entry = _entryBox.get(id);
    if (entry != null) {
      // Soft delete
      await _entryBox.put(
        id,
        entry.copyWith(
          isDeleted: true,
          syncStatus: SyncStatus.pending,
          lastModifiedAt: DateTime.now(),
        ),
      );
    }
  }

  List<Entry> getAllEntries() {
    return _entryBox.values.where((e) => !e.isDeleted).toList()
      ..sort((a, b) => b.result.savedAt.compareTo(a.result.savedAt));
  }

  List<Entry> getPendingEntries() {
    return _entryBox.values
        .where((e) => e.syncStatus == SyncStatus.pending)
        .toList();
  }

  Stream<List<Entry>> watchEntries() {
    return _entryBox.watch().map((_) => getAllEntries());
  }

  /// Helper to migrate from CaptureResult to Entry if needed
  Future<void> migrateFromCaptureResult(CaptureResult result) async {
    if (_entryBox.containsKey(result.jobId)) return;

    final entry = Entry(
      id: result.jobId,
      result: result,
      lastModifiedAt: result.savedAt,
      syncStatus: SyncStatus.pending,
    );
    await saveEntry(entry);
  }
}
