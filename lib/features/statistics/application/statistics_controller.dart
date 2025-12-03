import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/statistics/application/statistics_service.dart';
import 'package:qkomo_ui/features/statistics/domain/statistics_data.dart';

final statisticsControllerProvider = StateNotifierProvider.autoDispose<
    StatisticsController, AsyncValue<StatisticsData>>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  final service = ref.watch(statisticsServiceProvider);
  return StatisticsController(repository, service);
});

class StatisticsController extends StateNotifier<AsyncValue<StatisticsData>> {
  StatisticsController(this._repository, this._service)
      : super(const AsyncValue.loading()) {
    loadStatistics();
  }

  final CaptureResultRepository _repository;
  final StatisticsService _service;

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
      final data = _service.calculateStatistics(results);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadStatistics();
  }
}
