import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// UseCase: Calculate allergen occurrence counts
///
/// Returns a map of allergen name to occurrence count across all results.
class CalculateAllergenCounts {
  Map<String, int> call(List<CaptureResult> results) {
    final counts = <String, int>{};

    for (var result in results) {
      for (var allergen in result.allergens) {
        counts[allergen] = (counts[allergen] ?? 0) + 1;
      }
    }

    return counts;
  }
}
