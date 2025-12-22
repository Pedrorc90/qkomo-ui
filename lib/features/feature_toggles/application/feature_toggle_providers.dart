import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/feature_toggles/data/feature_toggle_repository.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle.dart';

final featureToggleRepositoryProvider = Provider<FeatureToggleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FeatureToggleRepository(dio);
});

final featureTogglesProvider = FutureProvider<List<FeatureToggle>>((ref) async {
  final repository = ref.watch(featureToggleRepositoryProvider);
  return repository.getFeatureToggles();
});

final featureEnabledProvider = Provider.family<bool, String>((ref, key) {
  final togglesAsync = ref.watch(featureTogglesProvider);
  return togglesAsync.when(
    data: (toggles) => toggles.any((t) => t.key == key && t.enabled),
    loading: () => false,
    error: (_, __) => false,
  );
});
