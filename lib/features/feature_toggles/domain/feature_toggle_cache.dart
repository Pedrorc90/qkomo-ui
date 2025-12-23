import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'feature_toggle_cache.freezed.dart';
part 'feature_toggle_cache.g.dart';

/// Metadata about cached feature toggles
@freezed
class FeatureToggleCacheMetadata with _$FeatureToggleCacheMetadata {
  @HiveType(typeId: 23, adapterName: 'FeatureToggleCacheMetadataAdapter')
  const factory FeatureToggleCacheMetadata({
    @HiveField(0) required DateTime lastUpdated,
    @HiveField(1) required int toggleCount,
  }) = _FeatureToggleCacheMetadata;

  factory FeatureToggleCacheMetadata.fromJson(Map<String, dynamic> json) =>
      _$FeatureToggleCacheMetadataFromJson(json);
}
