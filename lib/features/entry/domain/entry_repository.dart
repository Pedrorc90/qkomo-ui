import 'package:qkomo_ui/features/entry/domain/entry.dart';

abstract class EntryRepository {
  /// Get entries filtered by date range
  Future<List<Entry>> getEntries({DateTime? from, DateTime? to});

  /// Get a single entry by ID
  Future<Entry?> getEntryById(String id);

  /// Save an entry (create or update)
  Future<void> saveEntry(Entry entry);

  /// Delete an entry (soft delete)
  Future<void> deleteEntry(String id);

  /// Watch for changes in entries
  Stream<List<Entry>> watchEntries();

  /// Trigger sync process
  Future<void> sync();

  /// Get pending sync count
  Future<int> getPendingSyncCount();
}
