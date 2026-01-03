import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/core/network/api_endpoints.dart';
import 'package:qkomo_ui/features/feature_toggles/data/feature_toggle_hive_boxes.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/entities/feature_toggle.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/entities/feature_toggle_cache.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/repositories/feature_toggle_repository.dart';

class FeatureToggleRepositoryImpl implements FeatureToggleRepository {
  FeatureToggleRepositoryImpl(this._dio);
  final Dio _dio;

  /// Load feature toggles from cache
  ///
  /// Returns cached data if available, empty list otherwise.
  /// Does NOT throw errors - always returns a safe value.
  Future<List<FeatureToggle>> loadFromCache() async {
    try {
      final box = Hive.box<FeatureToggle>(FeatureToggleHiveBoxes.togglesBox);
      final togglesList = box.values.toList();
      debugPrint(
        '[FeatureToggleRepository] Loaded ${togglesList.length} toggles from cache: '
        '${togglesList.map((t) => '${t.key}=${t.enabled}').join(', ')}',
      );
      return togglesList;
    } catch (e) {
      debugPrint('[FeatureToggleRepository] Error loading from cache: $e');
      return [];
    }
  }

  /// Check if cache exists and has data
  bool hasCachedData() {
    try {
      final box = Hive.box<FeatureToggle>(FeatureToggleHiveBoxes.togglesBox);
      return box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get cache age in minutes (null if no cache exists)
  int? getCacheAgeMinutes() {
    try {
      final metadataBox = Hive.box<FeatureToggleCacheMetadata>(
        FeatureToggleHiveBoxes.metadataBox,
      );
      final metadata = metadataBox.get(FeatureToggleHiveBoxes.metadataKey);
      if (metadata == null) return null;

      final age = DateTime.now().difference(metadata.lastUpdated);
      return age.inMinutes;
    } catch (e) {
      return null;
    }
  }

  /// Fetch fresh toggles from API and update cache
  ///
  /// Returns fetched toggles or empty list on error.
  /// Handles both network errors and API errors gracefully.
  /// Uses 3s timeout for faster failure detection on unavailable backends.
  /// Marked as silent request to prevent retry overlay from blocking UI.
  Future<List<FeatureToggle>> refreshFromApi() async {
    try {
      debugPrint('[FeatureToggleRepository] Fetching feature toggles from API...');
      final response = await _dio.get(
        ApiEndpoints.features,
        options: Options(
          sendTimeout: kIsWeb ? null : const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          extra: {'silent_request': true}, // No mostrar overlay de reintentos
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('[FeatureToggleRepository] Raw API response: ${response.data}');
        final toggles = _parseFeatureToggles(response.data as Map<String, dynamic>);

        debugPrint(
          '[FeatureToggleRepository] API returned ${toggles.length} toggles: '
          '${toggles.map((t) => '${t.key}=${t.enabled}').join(', ')}',
        );

        // Save to cache
        await _saveToCache(toggles);

        return toggles;
      }
      debugPrint('[FeatureToggleRepository] API returned status code: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('[FeatureToggleRepository] Error fetching from API: $e');
      return [];
    }
  }

  /// Parse feature toggles from flat key-value map
  ///
  /// Converts the API response structure from:
  /// {
  ///   "ai_suggestions": true,
  ///   "companion": false,
  ///   "show_history": true
  /// }
  /// Into a list of FeatureToggle objects
  List<FeatureToggle> _parseFeatureToggles(Map<String, dynamic> data) {
    final toggles = <FeatureToggle>[];

    for (final entry in data.entries) {
      if (entry.value is bool) {
        toggles.add(FeatureToggle(
          key: entry.key,
          enabled: entry.value as bool,
          description: 'Feature toggle: ${entry.key}',
        ));
      }
    }

    return toggles;
  }

  /// Save toggles to cache with metadata
  Future<void> _saveToCache(List<FeatureToggle> toggles) async {
    try {
      final box = Hive.box<FeatureToggle>(FeatureToggleHiveBoxes.togglesBox);
      final metadataBox = Hive.box<FeatureToggleCacheMetadata>(FeatureToggleHiveBoxes.metadataBox);

      // Clear and repopulate box (atomic update)
      await box.clear();
      for (final toggle in toggles) {
        await box.put(toggle.key, toggle);
      }

      // Update metadata
      final metadata = FeatureToggleCacheMetadata(
        lastUpdated: DateTime.now(),
        toggleCount: toggles.length,
      );
      await metadataBox.put(FeatureToggleHiveBoxes.metadataKey, metadata);
      debugPrint('[FeatureToggleRepository] Saved ${toggles.length} toggles to cache');
    } catch (e) {
      debugPrint('[FeatureToggleRepository] Error saving to cache: $e');
    }
  }

  /// Clear all cached data (for debugging/testing)
  Future<void> clearCache() async {
    try {
      final box = Hive.box<FeatureToggle>(FeatureToggleHiveBoxes.togglesBox);
      final metadataBox = Hive.box<FeatureToggleCacheMetadata>(FeatureToggleHiveBoxes.metadataBox);

      await box.clear();
      await metadataBox.clear();
    } catch (e) {
      // Ignore errors on clear
    }
  }
}
