// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileDtoImpl _$$UserProfileDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileDtoImpl(
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dietaryPreferences: (json['dietaryPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileDtoImplToJson(
        _$UserProfileDtoImpl instance) =>
    <String, dynamic>{
      'firebaseUid': instance.firebaseUid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'allergens': instance.allergens,
      'dietaryPreferences': instance.dietaryPreferences,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
