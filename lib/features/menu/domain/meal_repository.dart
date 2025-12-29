import 'package:qkomo_ui/features/menu/domain/meal.dart';

/// Repository interface for Meal operations
/// Implementations can be local-only, remote-only, or hybrid (offline-first with cloud sync)
abstract class MealRepository {
  /// Get meals with optional date range filtering
  Future<List<Meal>> getMeals({DateTime? from, DateTime? to});

  /// Get a specific meal by ID
  Future<Meal?> getMealById(String id);

  /// Save a meal (create or update)
  Future<void> saveMeal(Meal meal);

  /// Delete a meal (soft delete for sync-enabled implementations)
  Future<void> deleteMeal(String id);

  /// Watch meals reactively (returns stream of changes)
  Stream<List<Meal>> watchMeals();

  /// Synchronize local changes with remote (no-op if cloud sync disabled)
  Future<void> sync();

  /// Get count of pending items waiting to be synced
  Future<int> getPendingSyncCount();
}
