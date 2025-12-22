import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/menu/application/menu_controller.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';
import 'package:qkomo_ui/features/menu/data/hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';

// Box provider
final mealBoxProvider = Provider<Box<Meal>>((ref) {
  return Hive.box<Meal>(MenuHiveBoxes.meals);
});

// Repository provider
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final box = ref.watch(mealBoxProvider);
  final user = ref.watch(firebaseAuthProvider).currentUser;

  // If no user is logged in, use empty string as userId
  // This ensures meals are isolated even when not logged in
  final userId = user?.uid ?? '';

  return MealRepository(mealBox: box, userId: userId);
});

// Stream provider for reactive updates
final mealsProvider = StreamProvider<List<Meal>>((ref) {
  final box = ref.watch(mealBoxProvider);
  final controller = StreamController<List<Meal>>();

  List<Meal> filtered() {
    final user = ref.read(firebaseAuthProvider).currentUser;
    final userId = user?.uid ?? '';
    final items = box.values.where((meal) => meal.userId == userId).toList();
    items.sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    return items;
  }

  controller.add(filtered());
  final sub = box.watch().listen((_) => controller.add(filtered()));

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
    return meal.scheduledFor
            .isAfter(weekStart.subtract(const Duration(days: 1))) &&
        meal.scheduledFor.isBefore(weekEnd);
  }).toList();
});

// Selected day provider
// Selected day provider
final selectedDayProvider = StateProvider<DateTime?>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

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
    return mealDate.year == now.year &&
        mealDate.month == now.month &&
        mealDate.day == now.day;
  }).toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
});

// All meals provider (for selecting existing meals)
final allMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  return allMeals;
});

// Controller provider
final menuControllerProvider =
    StateNotifierProvider<MenuController, MenuState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return MenuController(repository);
});
