import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../capture/application/capture_providers.dart';
import '../../capture/domain/capture_result.dart';
import '../../menu/application/menu_providers.dart';
import '../../menu/domain/meal.dart';

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
