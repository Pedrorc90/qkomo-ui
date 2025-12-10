// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaptureResultImpl _$$CaptureResultImplFromJson(Map<String, dynamic> json) =>
    _$CaptureResultImpl(
      jobId: json['jobId'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      title: json['title'] as String?,
      mealType: $enumDecodeNullable(_$MealTypeEnumMap, json['mealType']),
      isManualEntry: json['isManualEntry'] as bool? ?? false,
      isReviewed: json['isReviewed'] as bool? ?? false,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      userEdited: json['userEdited'] as bool? ?? false,
    );

Map<String, dynamic> _$$CaptureResultImplToJson(_$CaptureResultImpl instance) =>
    <String, dynamic>{
      'jobId': instance.jobId,
      'savedAt': instance.savedAt.toIso8601String(),
      'ingredients': instance.ingredients,
      'allergens': instance.allergens,
      'notes': instance.notes,
      'title': instance.title,
      'mealType': _$MealTypeEnumMap[instance.mealType],
      'isManualEntry': instance.isManualEntry,
      'isReviewed': instance.isReviewed,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'userEdited': instance.userEdited,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.snack: 'snack',
  MealType.dinner: 'dinner',
};
