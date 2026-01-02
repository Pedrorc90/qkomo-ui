import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// UseCase: Calculate current consecutive days streak
///
/// Returns 0 if:
/// - No results
/// - Last entry was before yesterday (streak broken)
///
/// Counts consecutive days with at least one entry.
class CalculateCurrentStreak {
  int call(List<CaptureResult> results) {
    if (results.isEmpty) return 0;

    // Sort results by date descending
    final sortedResults = List<CaptureResult>.from(results)
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));

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
    DateTime? lastDate;
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
}
