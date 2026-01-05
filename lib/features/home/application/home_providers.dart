import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';

// Today's entries
final todayEntriesProvider = Provider<List<CaptureResult>>((ref) {
  final allResults = ref.watch(captureResultsProvider).value ?? [];
  final now = DateTime.now();

  return allResults.where((result) {
    final date = result.savedAt;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }).toList()
    ..sort((a, b) => a.savedAt.compareTo(b.savedAt));
});

// Yesterday's entries
final yesterdayEntriesProvider = Provider<List<CaptureResult>>((ref) {
  final allResults = ref.watch(captureResultsProvider).value ?? [];
  final yesterday = DateTime.now().subtract(const Duration(days: 1));

  return allResults.where((result) {
    final date = result.savedAt;
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }).toList()
    ..sort((a, b) => a.savedAt.compareTo(b.savedAt));
});

// Tomorrow's planned meals
final tomorrowMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  final tomorrow = DateTime.now().add(const Duration(days: 1));

  return allMeals.where((meal) {
    final date = meal.scheduledFor;
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }).toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
});

// Next upcoming meal from today or tomorrow
final nextMealProvider = Provider<Meal?>((ref) {
  final todayMeals = ref.watch(todayMealsProvider);
  final tomorrowMeals = ref.watch(tomorrowMealsProvider);

  // If there are meals today, return the first one (regardless of time)
  if (todayMeals.isNotEmpty) {
    // Sort by scheduledFor and return the first
    todayMeals.sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    return todayMeals.first;
  }

  // If no meals today, return first meal tomorrow
  if (tomorrowMeals.isNotEmpty) {
    tomorrowMeals.sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    return tomorrowMeals.first;
  }

  return null;
});

// Most recent analysis/capture result
final lastAnalysisProvider = Provider<CaptureResult?>((ref) {
  final allResults = ref.watch(captureResultsProvider).value ?? [];
  if (allResults.isEmpty) return null;

  // Since captureResultsProvider already sorts by savedAt descending,
  // the first item is the most recent one.
  return allResults.first;
});

// Get current week's menu from local storage (Hive) - reactive stream
final currentWeeklyMenuProvider = StreamProvider<WeeklyMenu?>((ref) {
  final localRepo = ref.watch(localWeeklyMenuRepositoryProvider);
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final normalizedWeekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);

  debugPrint('[currentWeeklyMenuProvider] Looking for menu with weekStart: $normalizedWeekStart');

  // Watch all weekly menus and filter for current week
  return localRepo.watchWeeklyMenus().map((menus) {
    debugPrint('[currentWeeklyMenuProvider] Found ${menus.length} menus in Hive');
    for (final menu in menus) {
      debugPrint('[currentWeeklyMenuProvider] Menu weekStart: ${menu.weekStart}, days: ${menu.days.length}');
    }

    final found = menus.where((menu) {
      final menuWeekStart = DateTime(menu.weekStart.year, menu.weekStart.month, menu.weekStart.day);
      return menuWeekStart.isAtSameMomentAs(normalizedWeekStart);
    }).firstOrNull;

    debugPrint('[currentWeeklyMenuProvider] Found menu for current week: ${found != null}');
    return found;
  });
});

// Check if user has a generated weekly menu
final hasWeeklyMenuProvider = Provider<bool>((ref) {
  final weeklyMenu = ref.watch(currentWeeklyMenuProvider).value;
  final weekMeals = ref.watch(weekMealsProvider);

  // Check both: new WeeklyMenu from backend (stored in Hive) and legacy Meal entities
  return weeklyMenu != null || weekMeals.isNotEmpty;
});
