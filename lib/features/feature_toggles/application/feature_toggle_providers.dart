import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/feature_toggles/data/feature_toggle_repository.dart'
    as impl;
import 'package:qkomo_ui/features/feature_toggles/domain/entities/feature_toggle.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/repositories/feature_toggle_repository.dart';

/// Feature toggles that are enabled by default when no data is available
const _defaultEnabledToggles = <String>{};

final featureToggleRepositoryProvider =
    Provider<FeatureToggleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return impl.FeatureToggleRepositoryImpl(dio);
});

/// StateNotifier-based provider for feature toggles with cache-first loading
///
/// Behavior:
/// - If cache exists: Load cache immediately, refresh in background
/// - If no cache: Wait for API call (first install only)
/// - On error: Return empty list (safe fallback)
final featureTogglesProvider = StateNotifierProvider<FeatureToggleNotifier,
    AsyncValue<List<FeatureToggle>>>(
  (ref) {
    final repository = ref.watch(featureToggleRepositoryProvider);
    return FeatureToggleNotifier(repository);
  },
);

class FeatureToggleNotifier
    extends StateNotifier<AsyncValue<List<FeatureToggle>>> {
  FeatureToggleNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadToggles();
  }

  final FeatureToggleRepository _repository;

  /// Load toggles with cache-first strategy
  ///
  /// 1. Check if cache exists
  /// 2. If yes: Load immediately + trigger background refresh
  /// 3. If no: Wait for API call (first launch)
  Future<void> _loadToggles() async {
    final hasCached = _repository.hasCachedData();
    debugPrint(
        '[FeatureToggleNotifier] Starting load, has cached data: $hasCached');

    if (hasCached) {
      // CACHE HIT: Load immediately (non-blocking)
      final cached = await _repository.loadFromCache();
      debugPrint(
          '[FeatureToggleNotifier] Cache hit, loaded ${cached.length} toggles');
      state = AsyncValue.data(cached);

      // Trigger background refresh (fire-and-forget)
      unawaited(_refreshInBackground());
    } else {
      // CACHE MISS: Wait for API (first launch only)
      debugPrint('[FeatureToggleNotifier] Cache miss, fetching from API...');
      try {
        final toggles = await _repository.refreshFromApi();
        debugPrint(
            '[FeatureToggleNotifier] API fetch completed with ${toggles.length} toggles');
        state = AsyncValue.data(toggles);
      } catch (e) {
        debugPrint('[FeatureToggleNotifier] Error loading toggles: $e');
        // Even on error, set empty list (safe default)
        state = const AsyncValue.data([]);
      }
    }
  }

  /// Refresh from API in background without blocking UI
  ///
  /// - Fails silently if network is unavailable
  /// - Updates state only if fresh data is available
  /// - Preserves cached data on error
  Future<void> _refreshInBackground() async {
    debugPrint('[FeatureToggleNotifier] Background refresh started');
    try {
      final fresh = await _repository.refreshFromApi();
      if (fresh.isNotEmpty) {
        debugPrint(
            '[FeatureToggleNotifier] Background refresh got ${fresh.length} toggles, updating state');
        state = AsyncValue.data(fresh);
      } else {
        debugPrint(
            '[FeatureToggleNotifier] Background refresh returned empty, keeping cached data');
      }
    } catch (e) {
      debugPrint(
          '[FeatureToggleNotifier] Background refresh error: $e, keeping cached data');
    }
  }

  /// Force refresh (manual retry, pull-to-refresh, etc.)
  ///
  /// - Does not set loading state (keeps UI responsive)
  /// - Preserves current data on error
  /// - Allows recovery from network glitches
  Future<void> refresh() async {
    final current = state.valueOrNull ?? [];
    debugPrint('[FeatureToggleNotifier] Manual refresh initiated');

    try {
      final fresh = await _repository.refreshFromApi();
      if (fresh.isNotEmpty) {
        debugPrint(
            '[FeatureToggleNotifier] Manual refresh got ${fresh.length} toggles');
        state = AsyncValue.data(fresh);
      } else {
        debugPrint(
            '[FeatureToggleNotifier] Manual refresh returned empty, keeping current ${current.length} toggles');
        state = AsyncValue.data(current);
      }
    } catch (e, st) {
      debugPrint('[FeatureToggleNotifier] Manual refresh error: $e');
      state = AsyncValue.error(e, st);
      state = AsyncValue.data(current);
    }
  }

  /// Get cache age for debugging/monitoring
  int? getCacheAgeMinutes() => _repository.getCacheAgeMinutes();
}

/// Family provider to check if a specific feature is enabled
///
/// Returns default value for toggles when no data is available:
/// - Toggles in _defaultEnabledToggles: true
/// - All others: false
final featureEnabledProvider = Provider.family<bool, String>((ref, key) {
  final togglesAsync = ref.watch(featureTogglesProvider);
  final defaultValue = _defaultEnabledToggles.contains(key);

  return togglesAsync.when(
    data: (toggles) {
      // If toggle is found in data, use its value
      final toggle = toggles.firstWhere(
        (t) => t.key == key,
        orElse: () => FeatureToggle(key: key, enabled: defaultValue),
      );
      return toggle.enabled;
    },
    loading: () => defaultValue, // Use default during loading
    error: (_, __) => defaultValue, // Use default on error
  );
});
