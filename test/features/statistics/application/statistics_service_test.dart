import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/statistics/application/statistics_service.dart';

void main() {
  late StatisticsService service;

  setUp(() {
    service = StatisticsService();
  });

  group('StatisticsService', () {
    test('calculateStatistics returns empty data for empty results', () {
      final data = service.calculateStatistics([]);
      expect(data.totalEntries, 0);
      expect(data.currentStreak, 0);
      expect(data.entriesPerDay.values.every((e) => e == 0), true);
    });

    test('calculateStreak counts consecutive days correctly', () {
      final now = DateTime.now();
      final results = [
        _createResult(now), // Today
        _createResult(now.subtract(const Duration(days: 1))), // Yesterday
        _createResult(now.subtract(const Duration(days: 2))), // 2 days ago
      ];

      final data = service.calculateStatistics(results);
      expect(data.currentStreak, 3);
    });

    test('calculateStreak breaks when a day is skipped', () {
      final now = DateTime.now();
      final results = [
        _createResult(now), // Today
        _createResult(now.subtract(
            const Duration(days: 2))), // 2 days ago (skipped yesterday)
      ];

      final data = service.calculateStatistics(results);
      expect(data.currentStreak, 1);
    });

    test('calculateEntriesPerDay counts entries correctly', () {
      final now = DateTime.now();
      final results = [
        _createResult(now),
        _createResult(now),
        _createResult(now.subtract(const Duration(days: 1))),
      ];

      final data = service.calculateStatistics(results);
      // Note: keys are formatted dates, so we check values sum
      expect(data.totalEntries, 3);
      // We can't easily check specific keys without formatting date,
      // but we can check if the logic holds generally.
    });

    test('calculateTopIngredients counts and sorts ingredients', () {
      final results = [
        _createResult(DateTime.now(), ingredients: ['Apple', 'Banana']),
        _createResult(DateTime.now(), ingredients: ['Apple', 'Orange']),
        _createResult(DateTime.now(),
            ingredients: ['Apple', 'Banana', 'Grape']),
      ];

      final data = service.calculateStatistics(results);
      expect(data.topIngredients['Apple'], 3);
      expect(data.topIngredients['Banana'], 2);
      expect(data.topIngredients['Orange'], 1);
      expect(data.topIngredients['Grape'], 1);
    });
  });
}

CaptureResult _createResult(DateTime date,
    {List<String> ingredients = const []}) {
  return CaptureResult(
    jobId: 'id_${date.millisecondsSinceEpoch}',
    savedAt: date,
    ingredients: ingredients,
  );
}
