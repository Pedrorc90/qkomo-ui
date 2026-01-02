import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'feature_toggle.freezed.dart';
part 'feature_toggle.g.dart';

@freezed
class FeatureToggle with _$FeatureToggle {
  @HiveType(typeId: 24, adapterName: 'FeatureToggleAdapter')
  const factory FeatureToggle({
    @HiveField(0) required String key,
    @HiveField(1) required bool enabled,
    @HiveField(2) String? description,
  }) = _FeatureToggle;

  factory FeatureToggle.fromJson(Map<String, dynamic> json) =>
      _$FeatureToggleFromJson(json);
}
