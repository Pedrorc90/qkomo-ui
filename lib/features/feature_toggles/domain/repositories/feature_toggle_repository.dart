import 'package:qkomo_ui/features/feature_toggles/domain/entities/feature_toggle.dart';

/// Repository interface for feature toggles
///
/// Manages feature flags with offline-first caching.
/// Supports loading from cache and refreshing from remote API.
abstract class FeatureToggleRepository {
  /// Load feature toggles from cache
  ///
  /// Returns cached toggles if available, empty list otherwise.
  /// Never throws - always returns safe value.
  Future<List<FeatureToggle>> loadFromCache();

  /// Check if cached data exists
  bool hasCachedData();

  /// Get cache age in minutes (null if no cache)
  int? getCacheAgeMinutes();

  /// Refresh toggles from remote API
  ///
  /// Fetches from backend and updates cache.
  /// Returns empty list on error (offline-first).
  Future<List<FeatureToggle>> refreshFromApi();

  /// Clear all cached toggle data
  Future<void> clearCache();
}
