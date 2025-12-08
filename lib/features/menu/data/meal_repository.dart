import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class MealRepository {
  MealRepository({
    required Box<Meal> mealBox,
    required String userId,
    Uuid? uuid,
  })  : _mealBox = mealBox,
        _userId = userId,
        _uuid = uuid ?? const Uuid();

  final Box<Meal> _mealBox;
  final String _userId;
  final Uuid _uuid;

  Future<Meal> create({
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    required DateTime scheduledFor,
    String? notes,
  }) async {
    final meal = Meal(
      id: _uuid.v4(),
      userId: _userId,
      name: name,
      ingredients: ingredients,
      mealType: mealType,
      scheduledFor: scheduledFor,
      createdAt: DateTime.now(),
      notes: notes,
    );
    await _mealBox.put(meal.id, meal);
    return meal;
  }

  List<Meal> allSorted() {
    final items = _mealBox.values.where((meal) => meal.userId == _userId).toList();
    items.sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    return items;
  }

  List<Meal> forWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return _mealBox.values.where((meal) {
      return meal.userId == _userId &&
          meal.scheduledFor.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          meal.scheduledFor.isBefore(weekEnd);
    }).toList()
      ..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
  }

  List<Meal> forDay(DateTime date) {
    return _mealBox.values.where((meal) {
      final mealDate = meal.scheduledFor;
      return meal.userId == _userId &&
          mealDate.year == date.year &&
          mealDate.month == date.month &&
          mealDate.day == date.day;
    }).toList()
      ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
  }

  Meal? forDayAndType(DateTime date, MealType type) {
    final mealsOfDay = forDay(date);
    try {
      return mealsOfDay.firstWhere((meal) => meal.mealType == type);
    } catch (e) {
      return null;
    }
  }

  Meal? getById(String id) {
    return _mealBox.get(id);
  }

  Future<void> update(String id, Meal meal) async {
    final existing = _mealBox.get(id);
    if (existing == null) return;
    await _mealBox.put(
      id,
      meal.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<void> delete(String id) {
    return _mealBox.delete(id);
  }
}
