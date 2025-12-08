import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/menu/data/hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/application/menu_controller.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';

// Box provider
final mealBoxProvider = Provider<Box<Meal>>((ref) {
  return Hive.box<Meal>(MenuHiveBoxes.meals);
});

// Repository provider
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final box = ref.watch(mealBoxProvider);
  return MealRepository(mealBox: box);
});

// Stream provider for reactive updates
final mealsProvider = StreamProvider<List<Meal>>((ref) {
  final box = ref.watch(mealBoxProvider);
  final controller = StreamController<List<Meal>>();

  List<Meal> _sorted() {
    final items = box.values.toList();
    items.sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    return items;
  }

  controller.add(_sorted());
  final sub = box.watch().listen((_) => controller.add(_sorted()));

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

// Current week provider
final currentWeekStartProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  // Monday as first day of week
  return now.subtract(Duration(days: now.weekday - 1));
});

// Filtered meals for current week
final weekMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  final weekStart = ref.watch(currentWeekStartProvider);
  final weekEnd = weekStart.add(const Duration(days: 7));

  return allMeals.where((meal) {
    return meal.scheduledFor.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        meal.scheduledFor.isBefore(weekEnd);
  }).toList();
});

// Selected day provider
final selectedDayProvider = StateProvider<DateTime?>((ref) => null);

// Filtered meals for selected day
final selectedDayMealsProvider = Provider<List<Meal>>((ref) {
  final selectedDay = ref.watch(selectedDayProvider);
  if (selectedDay == null) return [];

  final allMeals = ref.watch(mealsProvider).value ?? [];

  return allMeals.where((meal) {
    final mealDate = meal.scheduledFor;
    return mealDate.year == selectedDay.year &&
        mealDate.month == selectedDay.month &&
        mealDate.day == selectedDay.day;
  }).toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
});

// Today's meals provider
final todayMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  final now = DateTime.now();

  return allMeals.where((meal) {
    final mealDate = meal.scheduledFor;
    return mealDate.year == now.year && mealDate.month == now.month && mealDate.day == now.day;
  }).toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
});

// Controller provider
final menuControllerProvider = StateNotifierProvider<MenuController, MenuState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return MenuController(repository);
});
