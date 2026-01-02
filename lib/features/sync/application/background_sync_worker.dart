import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/entry/data/hybrid_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/local_entry_repository.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';

import 'package:qkomo_ui/features/menu/data/hybrid_meal_repository.dart';
import 'package:qkomo_ui/features/menu/data/local_meal_repository.dart';
import 'package:qkomo_ui/features/menu/data/remote_meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:workmanager/workmanager.dart';

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

        // Register adapters if needed (V2 FIRST for Meal)
        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(CaptureResultAdapter());
        }
        if (!Hive.isAdapterRegistered(1)) {
          Hive.registerAdapter(EntryAdapter());
        }
        if (!Hive.isAdapterRegistered(6)) {
          Hive.registerAdapter(MealV2Adapter()); // Meal V2 adapter (ALWAYS)
        }
        // Note: V1 adapter NOT registered in background worker
        // (migration only runs in foreground)

        // Open boxes
        final entryBox = await Hive.openBox<Entry>('entries');
        final mealBox = await Hive.openBox<Meal>('meals');

        // Setup Entry repositories
        final localEntryRepo = LocalEntryRepository(entryBox: entryBox);
        final remoteEntryRepo = RemoteEntryRepository(dio: Dio());
        final hybridEntryRepo = HybridEntryRepository(
          localRepo: localEntryRepo,
          remoteRepo: remoteEntryRepo,
          enableCloudSync: true,
        );

        // Setup Meal repositories
        // TODO: Get userId from secure storage in background context
        final localMealRepo = LocalMealRepository(
          mealBox: mealBox,
          userId: '', // Background sync needs userId from auth
        );
        final remoteMealRepo = RemoteMealRepository(dio: Dio());
        final hybridMealRepo = HybridMealRepository(
          localRepo: localMealRepo,
          remoteRepo: remoteMealRepo,
          enableCloudSync: true,
        );

        // Run sync for both repositories
        await hybridEntryRepo.sync();
        await hybridMealRepo.sync();

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
