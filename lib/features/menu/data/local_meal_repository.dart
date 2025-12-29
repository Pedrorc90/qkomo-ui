import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Local-only repository for Meal operations using Hive
class LocalMealRepository {
  LocalMealRepository({
    required Box<Meal> mealBox,
    required String userId,
  })  : _mealBox = mealBox,
        _userId = userId;

  final Box<Meal> _mealBox;
  final String _userId;

  /// Save meal to local storage (create or update)
  Future<void> saveMeal(Meal meal) async {
    await _mealBox.put(meal.id, meal);
  }

  /// Get meal by ID (null if not found or deleted)
  Meal? getMealById(String id) {
    final meal = _mealBox.get(id);
    if (meal == null || meal.isDeleted) return null;
    return meal;
  }

  /// Soft delete meal (mark as deleted and pending sync)
  Future<void> deleteMeal(String id) async {
    final meal = _mealBox.get(id);
    if (meal == null) return;
    await _mealBox.put(
      id,
      meal.copyWith(
        isDeleted: true,
        syncStatus: SyncStatus.pending,
        lastModifiedAt: DateTime.now(),
      ),
    );
  }

  /// Get all non-deleted meals for current user, sorted by scheduledFor
  List<Meal> getAllMeals() {
    return _mealBox.values.where((meal) => meal.userId == _userId && !meal.isDeleted).toList()
      ..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
  }

  /// Get meals with pending sync status
  List<Meal> getPendingMeals() {
    return _mealBox.values
        .where((meal) => meal.userId == _userId && meal.syncStatus == SyncStatus.pending)
        .toList();
  }

  /// Watch meals reactively (emits list on any change)
  Stream<List<Meal>> watchMeals() {
    return _mealBox.watch().map((_) => getAllMeals());
  }

  // Helper methods migrated from old MealRepository

  /// Get meals for a specific week (Monday start)
  List<Meal> forWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return _mealBox.values.where((meal) {
      return meal.userId == _userId &&
          !meal.isDeleted &&
          meal.scheduledFor.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          meal.scheduledFor.isBefore(weekEnd);
    }).toList()
      ..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
  }

  /// Get meals for a specific day
  List<Meal> forDay(DateTime date) {
    return _mealBox.values.where((meal) {
      final mealDate = meal.scheduledFor;
      return meal.userId == _userId &&
          !meal.isDeleted &&
          mealDate.year == date.year &&
          mealDate.month == date.month &&
          mealDate.day == date.day;
    }).toList()
      ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
  }

  /// Get specific meal for day and type (null if not found)
  Meal? forDayAndType(DateTime date, MealType type) {
    final mealsOfDay = forDay(date);
    try {
      return mealsOfDay.firstWhere((meal) => meal.mealType == type);
    } catch (e) {
      return null;
    }
  }

  /// Delete all meals for a specific day (soft delete)
  Future<void> deleteForDay(DateTime date) async {
    final mealsToDelete = _mealBox.values.where((meal) {
      final mealDate = meal.scheduledFor;
      return meal.userId == _userId &&
          !meal.isDeleted &&
          mealDate.year == date.year &&
          mealDate.month == date.month &&
          mealDate.day == date.day;
    });

    for (final meal in mealsToDelete) {
      await deleteMeal(meal.id); // Use soft delete
    }
  }
}
