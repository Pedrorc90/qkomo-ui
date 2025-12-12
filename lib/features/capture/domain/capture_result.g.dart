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
      estimatedPortionG: (json['estimatedPortionG'] as num?)?.toInt(),
      nutrition: json['nutrition'] == null
          ? null
          : CaptureNutrition.fromJson(
              json['nutrition'] as Map<String, dynamic>),
      medicalAlerts: json['medicalAlerts'] == null
          ? null
          : CaptureMedicalAlerts.fromJson(
              json['medicalAlerts'] as Map<String, dynamic>),
      suitableFor: json['suitableFor'] == null
          ? null
          : CaptureSuitableFor.fromJson(
              json['suitableFor'] as Map<String, dynamic>),
      improvementSuggestions: (json['improvementSuggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      'estimatedPortionG': instance.estimatedPortionG,
      'nutrition': instance.nutrition,
      'medicalAlerts': instance.medicalAlerts,
      'suitableFor': instance.suitableFor,
      'improvementSuggestions': instance.improvementSuggestions,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.snack: 'snack',
  MealType.dinner: 'dinner',
};

_$CaptureNutritionImpl _$$CaptureNutritionImplFromJson(
        Map<String, dynamic> json) =>
    _$CaptureNutritionImpl(
      calories: (json['calories'] as num?)?.toInt(),
      proteinsG: (json['proteinsG'] as num?)?.toDouble(),
      carbohydratesG: (json['carbohydratesG'] as num?)?.toDouble(),
      fatsG: (json['fatsG'] as num?)?.toDouble(),
      fiberG: (json['fiberG'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CaptureNutritionImplToJson(
        _$CaptureNutritionImpl instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'proteinsG': instance.proteinsG,
      'carbohydratesG': instance.carbohydratesG,
      'fatsG': instance.fatsG,
      'fiberG': instance.fiberG,
    };

_$CaptureMedicalAlertsImpl _$$CaptureMedicalAlertsImplFromJson(
        Map<String, dynamic> json) =>
    _$CaptureMedicalAlertsImpl(
      diabetes: json['diabetes'] as String?,
      hypertension: json['hypertension'] as String?,
      cholesterol: json['cholesterol'] as String?,
    );

Map<String, dynamic> _$$CaptureMedicalAlertsImplToJson(
        _$CaptureMedicalAlertsImpl instance) =>
    <String, dynamic>{
      'diabetes': instance.diabetes,
      'hypertension': instance.hypertension,
      'cholesterol': instance.cholesterol,
    };

_$CaptureSuitableForImpl _$$CaptureSuitableForImplFromJson(
        Map<String, dynamic> json) =>
    _$CaptureSuitableForImpl(
      children: json['children'] as bool? ?? false,
      lowFodmap: json['lowFodmap'] as bool? ?? false,
      glutenFree: json['glutenFree'] as bool? ?? false,
      vegetarian: json['vegetarian'] as bool? ?? false,
      vegan: json['vegan'] as bool? ?? false,
    );

Map<String, dynamic> _$$CaptureSuitableForImplToJson(
        _$CaptureSuitableForImpl instance) =>
    <String, dynamic>{
      'children': instance.children,
      'lowFodmap': instance.lowFodmap,
      'glutenFree': instance.glutenFree,
      'vegetarian': instance.vegetarian,
      'vegan': instance.vegan,
    };
