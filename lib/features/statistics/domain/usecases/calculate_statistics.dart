import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/statistics/domain/entities/statistics_data.dart';
import 'package:qkomo_ui/features/statistics/domain/usecases/calculate_allergen_counts.dart';
import 'package:qkomo_ui/features/statistics/domain/usecases/calculate_current_streak.dart';
import 'package:qkomo_ui/features/statistics/domain/usecases/calculate_entries_per_day.dart';
import 'package:qkomo_ui/features/statistics/domain/usecases/calculate_top_ingredients.dart';

/// UseCase: Calculate complete statistics from capture results
///
/// Orchestrates multiple sub-usecases to build a complete StatisticsData object.
/// This is the main entry point for statistics calculation.
class CalculateStatistics {
  CalculateStatistics({
    CalculateCurrentStreak? calculateCurrentStreak,
    CalculateEntriesPerDay? calculateEntriesPerDay,
    CalculateTopIngredients? calculateTopIngredients,
    CalculateAllergenCounts? calculateAllergenCounts,
  })  : _calculateCurrentStreak = calculateCurrentStreak ?? CalculateCurrentStreak(),
        _calculateEntriesPerDay = calculateEntriesPerDay ?? CalculateEntriesPerDay(),
        _calculateTopIngredients = calculateTopIngredients ?? CalculateTopIngredients(),
        _calculateAllergenCounts = calculateAllergenCounts ?? CalculateAllergenCounts();

  final CalculateCurrentStreak _calculateCurrentStreak;
  final CalculateEntriesPerDay _calculateEntriesPerDay;
  final CalculateTopIngredients _calculateTopIngredients;
  final CalculateAllergenCounts _calculateAllergenCounts;

  StatisticsData call(List<CaptureResult> results) {
    if (results.isEmpty) {
      return StatisticsData.empty();
    }

    final totalEntries = results.length;
    final currentStreak = _calculateCurrentStreak(results);
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
}
