import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_toggle.freezed.dart';
part 'feature_toggle.g.dart';

@freezed
class FeatureToggle with _$FeatureToggle {
  const factory FeatureToggle({
    required String key,
    required bool enabled,
    String? description,
  }) = _FeatureToggle;

  factory FeatureToggle.fromJson(Map<String, dynamic> json) =>
      _$FeatureToggleFromJson(json);
}
