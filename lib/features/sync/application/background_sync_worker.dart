import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/core/config/feature_flags.dart';
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

        // Register Meal adapter (V2)
        if (!Hive.isAdapterRegistered(6)) {
          Hive.registerAdapter(MealV2Adapter());
        }

        // Open Meal box
        final mealBox = await Hive.openBox<Meal>('meals');

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

        // Run sync for Meals
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
