import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/history/utils/date_grouping_helper.dart';
import 'package:qkomo_ui/features/history/application/history_controller.dart';

/// Statistics for a date group
class DateGroupStats {
  final int mealCount;
  final int ingredientCount;

  const DateGroupStats({
    required this.mealCount,
    required this.ingredientCount,
  });
}

/// Provider for history controller
final historyControllerProvider =
    StateNotifierProvider<HistoryController, HistoryState>((ref) {
  return HistoryController();
});

/// Provider for filtered entries based on date filter and search
final filteredEntriesProvider = Provider<List<Entry>>((ref) {
  final state = ref.watch(historyControllerProvider);
  // Use entriesStreamProvider to get the latest list of entries
  final entriesAsync = ref.watch(entriesStreamProvider);

  // If loading or error, return empty list (or handle appropriately in UI)
  final allEntries = entriesAsync.value ?? [];

  // Get entries based on date filter
  List<Entry> filteredEntries;
  switch (state.dateFilter) {
    case DateFilter.today:
      filteredEntries = allEntries
          .where((e) => DateGroupingHelper.isToday(e.result.savedAt))
          .toList();
      break;
    case DateFilter.thisWeek:
      filteredEntries = allEntries
          .where((e) => DateGroupingHelper.isThisWeek(e.result.savedAt))
          .toList();
      break;
    case DateFilter.all:
      filteredEntries = allEntries;
      break;
  }

  // Apply search filter if query exists
  if (state.hasSearch) {
    final query = state.searchQuery.toLowerCase();
    filteredEntries = filteredEntries.where((entry) {
      final result = entry.result;
      // Search by title
      if (result.title != null && result.title!.toLowerCase().contains(query)) {
        return true;
      }

      // Search by ingredients
      for (final ingredient in result.ingredients) {
        if (ingredient.toLowerCase().contains(query)) {
          return true;
        }
      }

      // Search by allergens
      for (final allergen in result.allergens) {
        if (allergen.toLowerCase().contains(query)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  return filteredEntries;
});

/// Provider for grouped entries by date
final groupedEntriesProvider = Provider<Map<DateGroup, List<Entry>>>((ref) {
  final entries = ref.watch(filteredEntriesProvider);
  return DateGroupingHelper.groupEntriesByDate(entries);
});

/// Deprecated: Use filteredEntriesProvider instead
final filteredResultsProvider = Provider<List<CaptureResult>>((ref) {
  final entries = ref.watch(filteredEntriesProvider);
  return entries.map((e) => e.result).toList();
});

/// Deprecated: Use groupedEntriesProvider instead
final groupedResultsProvider =
    Provider<Map<DateGroup, List<CaptureResult>>>((ref) {
  final results = ref.watch(filteredResultsProvider);
  return DateGroupingHelper.groupResultsByDate(results);
});

/// Provider for stream of all entries (for pull-to-refresh)
/// This is just an alias for entriesStreamProvider now
final resultsStreamProvider = StreamProvider<List<Entry>>((ref) {
  return ref.watch(entriesStreamProvider.stream);
});

/// Provider for counting entries by date filter
final filterCountsProvider = Provider<Map<DateFilter, int>>((ref) {
  final entriesAsync = ref.watch(entriesStreamProvider);
  final allEntries = entriesAsync.value ?? [];

  return {
    DateFilter.today: allEntries
        .where((e) => DateGroupingHelper.isToday(e.result.savedAt))
        .length,
    DateFilter.thisWeek: allEntries
        .where((e) => DateGroupingHelper.isThisWeek(e.result.savedAt))
        .length,
    DateFilter.all: allEntries.length,
  };
});

/// Provider for statistics of each date group
final dateGroupStatsProvider =
    Provider<Map<DateGroup, DateGroupStats>>((ref) {
  final groupedEntries = ref.watch(groupedEntriesProvider);

  return {
    for (final group in DateGroup.values)
      group: _calculateStatsForGroup(groupedEntries[group] ?? []),
  };
});

/// Calculate statistics for a group of entries
DateGroupStats _calculateStatsForGroup(List<Entry> entries) {
  final ingredientSet = <String>{};
  for (final entry in entries) {
    ingredientSet.addAll(entry.result.ingredients);
  }

  return DateGroupStats(
    mealCount: entries.length,
    ingredientCount: ingredientSet.length,
  );
}
