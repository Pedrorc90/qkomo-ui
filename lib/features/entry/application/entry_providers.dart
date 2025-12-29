import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entry_repository.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/data/hybrid_meal_repository.dart';
import 'package:qkomo_ui/features/sync/application/sync_service.dart';

/// Provider for the Hive box storing entries
final entryBoxProvider = Provider<Box<Entry>>((ref) {
  return Hive.box<Entry>('entries');
});

/// Provider for Connectivity
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider for LocalEntryRepository
final localEntryRepositoryProvider = Provider<LocalEntryRepository>((ref) {
  final box = ref.watch(entryBoxProvider);
  return LocalEntryRepository(entryBox: box);
});

/// Provider for RemoteEntryRepository
final remoteEntryRepositoryProvider = Provider<RemoteEntryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RemoteEntryRepository(dio: dio);
});

/// Provider for the main EntryRepository (Hybrid)
final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  final localRepo = ref.watch(localEntryRepositoryProvider);
  final remoteRepo = ref.watch(remoteEntryRepositoryProvider);

  return HybridEntryRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    enableCloudSync: EnvConfig.enableCloudSync,
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

/// Provider for SyncService (multi-repository sync)
final syncServiceProvider = Provider<SyncService>((ref) {
  final entryRepo = ref.watch(entryRepositoryProvider) as HybridEntryRepository;
  final mealRepo = ref.watch(mealRepositoryProvider) as HybridMealRepository;
  final connectivity = ref.watch(connectivityProvider);

  final service = SyncService(
    repositories: [entryRepo, mealRepo], // Multi-repository sync
    connectivity: connectivity,
  );

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Stream provider for sync status
final syncStatusStreamProvider = StreamProvider<SyncStatus>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.syncStatusStream;
});

/// Stream provider for last sync time
final lastSyncTimeStreamProvider = StreamProvider<DateTime?>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.lastSyncTimeStream;
});
