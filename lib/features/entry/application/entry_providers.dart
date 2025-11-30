import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entry_repository.dart';

/// Provider for the Hive box storing entries
final entryBoxProvider = Provider<Box<Entry>>((ref) {
  return Hive.box<Entry>('entries');
});

/// Provider for LocalEntryRepository
final localEntryRepositoryProvider = Provider<LocalEntryRepository>((ref) {
  final box = ref.watch(entryBoxProvider);
  return LocalEntryRepository(entryBox: box);
});

/// Provider for RemoteEntryRepository
final remoteEntryRepositoryProvider = Provider<RemoteEntryRepository>((ref) {
  return RemoteEntryRepository();
});

/// Provider for the main EntryRepository (Hybrid)
final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  final localRepo = ref.watch(localEntryRepositoryProvider);
  final remoteRepo = ref.watch(remoteEntryRepositoryProvider);

  return HybridEntryRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
  );
});

/// Stream of all entries
final entriesStreamProvider = StreamProvider<List<Entry>>((ref) {
  final repo = ref.watch(entryRepositoryProvider);
  return repo.watchEntries();
});

/// Provider for pending sync count
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(entryRepositoryProvider);
  return repo.getPendingSyncCount();
});
