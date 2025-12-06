import 'dart:async';

import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';

class HybridEntryRepository implements EntryRepository {
  HybridEntryRepository({
    required LocalEntryRepository localRepo,
    required RemoteEntryRepository remoteRepo,
    this.enableCloudSync = false,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo;

  final LocalEntryRepository _localRepo;
  final RemoteEntryRepository _remoteRepo;
  final bool enableCloudSync;

  @override
  Future<List<Entry>> getEntries({DateTime? from, DateTime? to}) async {
    // Return local entries immediately (Offline-first)
    var entries = _localRepo.getAllEntries();

    if (from != null) {
      entries = entries
          .where((e) =>
              e.result.savedAt.isAfter(from.subtract(const Duration(days: 1))))
          .toList();
    }
    if (to != null) {
      entries = entries
          .where(
              (e) => e.result.savedAt.isBefore(to.add(const Duration(days: 1))))
          .toList();
    }

    return entries;
  }

  @override
  Future<Entry?> getEntryById(String id) async {
    return _localRepo.getEntryById(id);
  }

  @override
  Future<void> saveEntry(Entry entry) async {
    // 1. Save locally first (Optimistic UI)
    final entryToSave = entry.copyWith(
      syncStatus: SyncStatus.pending,
      lastModifiedAt: DateTime.now(),
    );
    await _localRepo.saveEntry(entryToSave);

    // 2. Trigger sync in background (fire and forget)
    _syncSingle(entryToSave);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _localRepo.deleteEntry(id);
    // Trigger sync to propagate delete
    sync();
  }

  @override
  Stream<List<Entry>> watchEntries() {
    return _localRepo.watchEntries();
  }

  @override
  Future<void> sync() async {
    final pending = _localRepo.getPendingEntries();
    for (final entry in pending) {
      await _syncSingle(entry);
    }
  }

  @override
  Future<int> getPendingSyncCount() async {
    return _localRepo.getPendingEntries().length;
  }

  Future<void> _syncSingle(Entry entry) async {
    // Skip remote sync if cloud sync is disabled
    if (!enableCloudSync) {
      return;
    }

    try {
      if (entry.isDeleted) {
        await _remoteRepo.deleteEntry(entry.id);
      } else {
        await _remoteRepo.pushEntry(entry);
      }

      // Mark as synced locally
      await _localRepo.saveEntry(entry.copyWith(
        syncStatus: SyncStatus.synced,
        lastSyncedAt: DateTime.now(),
      ));
    } catch (e) {
      // Mark as failed
      await _localRepo.saveEntry(entry.copyWith(
        syncStatus: SyncStatus.failed,
      ));
      // TODO: Log error
    }
  }
}
