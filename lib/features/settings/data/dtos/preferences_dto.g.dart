// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreferencesDtoImpl _$$PreferencesDtoImplFromJson(Map<String, dynamic> json) =>
    _$PreferencesDtoImpl(
      allergens: json['allergens'] as String?,
      dietaryPreferences: json['dietary_preferences'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PreferencesDtoImplToJson(
        _$PreferencesDtoImpl instance) =>
    <String, dynamic>{
      'allergens': instance.allergens,
      'dietary_preferences': instance.dietaryPreferences,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
