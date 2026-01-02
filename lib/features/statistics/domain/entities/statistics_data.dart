import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_data.freezed.dart';

@freezed
class StatisticsData with _$StatisticsData {
  const factory StatisticsData({
    required int totalEntries,
    required int currentStreak,
    required Map<String, int>
        entriesPerDay, // Date string (yyyy-MM-dd) -> count
    required Map<String, int> topIngredients, // Ingredient name -> count
    required Map<String, int> allergenCounts, // Allergen name -> count
  }) = _StatisticsData;

  factory StatisticsData.empty() => const StatisticsData(
        totalEntries: 0,
        currentStreak: 0,
        entriesPerDay: {},
        topIngredients: {},
        allergenCounts: {},
      );
}
