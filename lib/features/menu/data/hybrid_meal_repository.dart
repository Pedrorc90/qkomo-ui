import 'dart:async';

import 'package:qkomo_ui/core/services/logger_service.dart';
import 'package:qkomo_ui/core/sync/sync_status.dart';
import 'package:qkomo_ui/core/sync/sync_status.dart';
import 'package:qkomo_ui/features/menu/data/local_meal_repository.dart';
import 'package:qkomo_ui/features/menu/data/remote_meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/sync/domain/interfaces/syncable_repository.dart';

/// Hybrid repository implementing offline-first pattern with cloud sync
class HybridMealRepository implements MealRepository, SyncableRepository {
  @override
  String get repositoryName => 'Meal';
  HybridMealRepository({
    required LocalMealRepository localRepo,
    required RemoteMealRepository remoteRepo,
    this.enableCloudSync = false,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo;

  final LocalMealRepository _localRepo;
  final RemoteMealRepository _remoteRepo;
  final bool enableCloudSync;

  @override
  Future<List<Meal>> getMeals({DateTime? from, DateTime? to}) async {
    // Return local meals immediately (offline-first)
    var meals = _localRepo.getAllMeals();

    if (from != null) {
      meals = meals
          .where((m) =>
              m.scheduledFor.isAfter(from.subtract(const Duration(days: 1))))
          .toList();
    }
    if (to != null) {
      meals = meals
          .where(
              (m) => m.scheduledFor.isBefore(to.add(const Duration(days: 1))))
          .toList();
    }

    return meals;
  }

  @override
  Future<Meal?> getMealById(String id) async {
    return _localRepo.getMealById(id);
  }

  @override
  Future<void> saveMeal(Meal meal) async {
    // 1. Save locally first (optimistic UI)
    final mealToSave = meal.copyWith(
      syncStatus: SyncStatus.pending,
      lastModifiedAt: DateTime.now(),
    );
    await _localRepo.saveMeal(mealToSave);

    // 2. Trigger sync in background (fire and forget)
    unawaited(_syncSingle(mealToSave));
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _localRepo.deleteMeal(id);
    // Trigger sync to propagate delete
    unawaited(sync());
  }

  @override
  Stream<List<Meal>> watchMeals() {
    return _localRepo.watchMeals();
  }

  @override
  Future<void> sync() async {
    if (!enableCloudSync) return;

    // 1. PULL: Fetch remote updates since last sync
    final lastSynced = _localRepo
        .getAllMeals()
        .map((m) => m.lastSyncedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);

    Exception? syncError;

    try {
      final remoteMeals = await _remoteRepo.fetchMeals(from: lastSynced);

      for (final remoteMeal in remoteMeals) {
        final localMeal = _localRepo.getMealById(remoteMeal.id);

        if (localMeal == null) {
          // New from cloud → save locally
          await _localRepo.saveMeal(remoteMeal);
        } else {
          // Conflict detection
          if (localMeal.syncStatus == SyncStatus.pending ||
              localMeal.syncStatus == SyncStatus.failed ||
              localMeal.syncStatus == SyncStatus.conflict) {
            // Local changes exist → CONFLICT
            final mealWithConflict = localMeal.copyWith(
              syncStatus: SyncStatus.conflict,
            );
            await _localRepo.saveMeal(mealWithConflict);
          } else {
            // Local is synced/clean → safe to overwrite with remote
            await _localRepo.saveMeal(remoteMeal);
          }
        }
      }
    } catch (e, stackTrace) {
      // Pull failed - log and continue to push attempt
      LogService().e(
        'Error al obtener comidas del servidor durante sync',
        e,
        stackTrace,
      );
      syncError = e is Exception ? e : Exception(e.toString());
      // Continue to push attempt even if pull failed
    }

    // 2. PUSH: Send pending local changes
    final pending = _localRepo.getPendingMeals();
    for (final meal in pending) {
      await _syncSingle(meal);
    }

    // If pull failed, propagate error to caller for UI feedback
    if (syncError != null) {
      throw syncError;
    }
  }

  @override
  Future<int> getPendingSyncCount() async {
    return _localRepo.getPendingMeals().length;
  }

  /// Sync a single meal in the background
  Future<void> _syncSingle(Meal meal) async {
    // Skip remote sync if cloud sync is disabled
    if (!enableCloudSync) {
      return;
    }

    try {
      if (meal.isDeleted) {
        await _remoteRepo.deleteMeal(meal.id);
      } else {
        await _remoteRepo.pushMeal(meal);
      }

      // Mark as synced locally
      await _localRepo.saveMeal(meal.copyWith(
        syncStatus: SyncStatus.synced,
        lastSyncedAt: DateTime.now(),
      ));
    } on ConflictException catch (e, stackTrace) {
      // 409 Conflict → mark locally and log
      LogService().w(
        'Conflicto al sincronizar meal ${meal.id}',
        e,
        stackTrace,
      );
      await _localRepo.saveMeal(meal.copyWith(
        syncStatus: SyncStatus.conflict,
      ));
    } catch (e, stackTrace) {
      // Mark as failed and log
      LogService().e(
        'Error al sincronizar meal ${meal.id}',
        e,
        stackTrace,
      );
      await _localRepo.saveMeal(meal.copyWith(
        syncStatus: SyncStatus.failed,
      ));
      // Note: No rethrow - called with unawaited() for background sync
    }
  }
}
