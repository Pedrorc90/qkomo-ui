import 'package:intl/intl.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// UseCase: Calculate entries per day for the last 7 days
///
/// Returns a map of date string (yyyy-MM-dd) to entry count.
/// Initializes all 7 days with 0, even if no entries exist.
class CalculateEntriesPerDay {
  Map<String, int> call(List<CaptureResult> results) {
    final map = <String, int>{};
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Initialize last 7 days with 0
    final now = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      map[dateFormat.format(day)] = 0;
    }

    // Count entries per day
    for (var result in results) {
      final dateKey = dateFormat.format(result.savedAt);
      if (map.containsKey(dateKey)) {
        map[dateKey] = (map[dateKey] ?? 0) + 1;
      }
    }

    return map;
  }
}
