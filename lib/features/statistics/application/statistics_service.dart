import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/statistics/domain/entities/statistics_data.dart';

final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService();
});

class StatisticsService {
  StatisticsData calculateStatistics(List<CaptureResult> results) {
    if (results.isEmpty) {
      return StatisticsData.empty();
    }

    // Sort results by date descending
    final sortedResults = List<CaptureResult>.from(results)
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));

    final totalEntries = results.length;
    final currentStreak = _calculateStreak(sortedResults);
    final entriesPerDay = _calculateEntriesPerDay(results);
    final topIngredients = _calculateTopIngredients(results);
    final allergenCounts = _calculateAllergenCounts(results);

    return StatisticsData(
      totalEntries: totalEntries,
      currentStreak: currentStreak,
      entriesPerDay: entriesPerDay,
      topIngredients: topIngredients,
      allergenCounts: allergenCounts,
    );
  }

  int _calculateStreak(List<CaptureResult> sortedResults) {
    if (sortedResults.isEmpty) return 0;

    var streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if there's an entry for today or yesterday to start the streak
    final firstEntryDate = sortedResults.first.savedAt;
    final firstEntryDay =
        DateTime(firstEntryDate.year, firstEntryDate.month, firstEntryDate.day);

    if (firstEntryDay.isBefore(today.subtract(const Duration(days: 1)))) {
      return 0; // Streak broken if last entry was before yesterday
    }

    // Count consecutive days
    DateTime? lastDate;

    // Create a set of unique days present in the results
    final uniqueDays = sortedResults
        .map((r) {
          return DateTime(r.savedAt.year, r.savedAt.month, r.savedAt.day);
        })
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    if (uniqueDays.isEmpty) return 0;

    // Check if the most recent day is today or yesterday
    if (uniqueDays.first.isBefore(today.subtract(const Duration(days: 1)))) {
      return 0;
    }

    // Iterate backwards from the most recent day
    for (var i = 0; i < uniqueDays.length; i++) {
      final currentDay = uniqueDays[i];

      if (i == 0) {
        streak = 1;
        lastDate = currentDay;
        continue;
      }

      if (lastDate != null &&
          currentDay
              .isAtSameMomentAs(lastDate.subtract(const Duration(days: 1)))) {
        streak++;
        lastDate = currentDay;
      } else {
        break;
      }
    }

    return streak;
  }

  Map<String, int> _calculateEntriesPerDay(List<CaptureResult> results) {
    final map = <String, int>{};
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Initialize last 7 days with 0
    final now = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      map[dateFormat.format(day)] = 0;
    }

    for (var result in results) {
      final dateKey = dateFormat.format(result.savedAt);
      if (map.containsKey(dateKey)) {
        map[dateKey] = (map[dateKey] ?? 0) + 1;
      }
    }

    return map;
  }

  Map<String, int> _calculateTopIngredients(List<CaptureResult> results) {
    final counts = <String, int>{};

    for (var result in results) {
      for (var ingredient in result.ingredients) {
        counts[ingredient] = (counts[ingredient] ?? 0) + 1;
      }
    }

    // Sort by count descending and take top 5
    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = <String, int>{};
    for (var i = 0; i < sortedEntries.length && i < 5; i++) {
      top5[sortedEntries[i].key] = sortedEntries[i].value;
    }

    return top5;
  }

  Map<String, int> _calculateAllergenCounts(List<CaptureResult> results) {
    final counts = <String, int>{};

    for (var result in results) {
      for (var allergen in result.allergens) {
        counts[allergen] = (counts[allergen] ?? 0) + 1;
      }
    }

    return counts;
  }
}
