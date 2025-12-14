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
    unawaited(_syncSingle(entryToSave));
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _localRepo.deleteEntry(id);
    // Trigger sync to propagate delete
    unawaited(sync());
  }

  @override
  Stream<List<Entry>> watchEntries() {
    return _localRepo.watchEntries();
  }

  @override
  Future<void> sync() async {
    if (!enableCloudSync) return;

    // 1. PULL: Fetch remote updates since last sync
    // We get the most recent synced time across all entries to know where to start
    // (In a real app, we might want a global 'lastSyncTime' pref/metadata)
    final lastSynced = _localRepo
        .getAllEntries()
        .map((e) => e.lastSyncedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);

    try {
      final remoteEntries = await _remoteRepo.fetchEntries(from: lastSynced);

      for (final remoteEntry in remoteEntries) {
        final localEntry = await _localRepo.getEntryById(remoteEntry.id);

        if (localEntry == null) {
          // New from cloud -> save locally
          await _localRepo.saveEntry(remoteEntry);
        } else {
          // Conflict detection
          if (localEntry.syncStatus == SyncStatus.pending ||
              localEntry.syncStatus == SyncStatus.failed ||
              localEntry.syncStatus == SyncStatus.conflict) {
            // Check if remote is actually newer than what we based our changes on
            // (Simple version: if we have local changes, it's a conflict)
            final entryWithConflict = localEntry.copyWith(
              syncStatus: SyncStatus.conflict,
              // Potentially store the remote version in pendingChanges or similar
              // for now just marking as conflict so user can see it
            );
            await _localRepo.saveEntry(entryWithConflict);
          } else {
            // Local is synced or clean -> safe to overwrite with newer remote
            await _localRepo.saveEntry(remoteEntry);
          }
        }
      }
    } catch (e) {
      // Pull failed - log and continue to push attempt?
      // Often better to stop if pull fails to avoid pushing on stale state
      // But for offline-first, we might still want to push our changes.
      // We'll catch and log, then try to push.
      // TODO: Log error
    }

    // 2. PUSH: Send pending local changes
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
        // If backend returns the saved entry with new version, we should use that
        // But pushEntry currently returns void.
      ));
    } on ConflictException catch (_) {
      // 409 Conflict -> Mark locally
      await _localRepo.saveEntry(entry.copyWith(
        syncStatus: SyncStatus.conflict,
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
