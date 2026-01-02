import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// UseCase: Calculate top 5 most frequent ingredients
///
/// Returns a map of ingredient name to occurrence count,
/// sorted by count descending, limited to top 5.
class CalculateTopIngredients {
  Map<String, int> call(List<CaptureResult> results) {
    final counts = <String, int>{};

    // Count ingredient occurrences
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
}
