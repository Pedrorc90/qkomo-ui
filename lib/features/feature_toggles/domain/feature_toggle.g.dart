// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_toggle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureToggleImpl _$$FeatureToggleImplFromJson(Map<String, dynamic> json) =>
    _$FeatureToggleImpl(
      key: json['key'] as String,
      enabled: json['enabled'] as bool,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$FeatureToggleImplToJson(_$FeatureToggleImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'enabled': instance.enabled,
      'description': instance.description,
    };
