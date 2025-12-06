import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';

const String syncTaskName = 'qkomo_sync_task';

/// Top-level function for Workmanager callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == syncTaskName) {
      if (!FeatureFlags.enableCloudSync) return Future.value(true);

      try {
        // Initialize Hive for background isolate
        await Hive.initFlutter();

        // Register adapters if needed (check if they are already registered)
        if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(CaptureResultAdapter());
        if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(EntryAdapter());
        // Add other adapters as needed...

        // Open boxes
        final entryBox = await Hive.openBox<Entry>('entries');

        // Setup repositories
        final localRepo = LocalEntryRepository(entryBox: entryBox);
        final remoteRepo = RemoteEntryRepository(dio: Dio()); // Configure Dio as needed
        final hybridRepo = HybridEntryRepository(
          localRepo: localRepo,
          remoteRepo: remoteRepo,
          enableCloudSync: true,
        );

        // Run sync
        await hybridRepo.sync();

        return Future.value(true);
      } catch (e) {
        debugPrint('Background sync failed: $e');
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

class BackgroundSyncWorker {
  /// Initialize background worker
  static Future<void> init() async {
    if (!FeatureFlags.enableCloudSync) return;

    await Workmanager().initialize(
      callbackDispatcher,
    );
  }

  /// Register periodic sync task
  static Future<void> registerPeriodicSync() async {
    if (!FeatureFlags.enableCloudSync) return;

    await Workmanager().registerPeriodicTask(
      'qkomo_periodic_sync',
      syncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
