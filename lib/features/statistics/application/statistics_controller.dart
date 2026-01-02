import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';
import 'package:qkomo_ui/features/statistics/domain/entities/statistics_data.dart';
import 'package:qkomo_ui/features/statistics/domain/usecases/calculate_statistics.dart';

// UseCase provider
final calculateStatisticsProvider = Provider<CalculateStatistics>((ref) {
  return CalculateStatistics();
});

final statisticsControllerProvider = StateNotifierProvider.autoDispose<
    StatisticsController, AsyncValue<StatisticsData>>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  final calculateStatistics = ref.watch(calculateStatisticsProvider);
  return StatisticsController(repository, calculateStatistics);
});

class StatisticsController extends StateNotifier<AsyncValue<StatisticsData>> {
  StatisticsController(this._repository, this._calculateStatistics)
      : super(const AsyncValue.loading()) {
    loadStatistics();
  }

  final CaptureResultRepository _repository;
  final CalculateStatistics _calculateStatistics;

  Future<void> loadStatistics() async {
    try {
      state = const AsyncValue.loading();
      // Fetch all results. Assuming getAllResults exists or similar.
      // If not, we might need to add it or use getResults with a wide range.
      // Based on typical repository patterns, let's assume getAllResults or we can fetch a large range.
      // Checking the repository file content will confirm this.
      // For now, I'll assume getAllResults() is available or I'll implement it.
      // If the repository only has getResults(from, to), I'll use a wide range.

      // Fetch all results
      final results = _repository.allSorted();
      final data = _calculateStatistics(results);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadStatistics();
  }
}
