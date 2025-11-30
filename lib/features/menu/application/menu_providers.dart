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

// Controller provider
final menuControllerProvider = StateNotifierProvider<MenuController, MenuState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return MenuController(repository);
});
