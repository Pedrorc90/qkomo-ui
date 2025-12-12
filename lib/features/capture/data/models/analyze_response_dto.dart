class AnalyzeResponseDto {
  AnalyzeResponseDto({
    required this.analysisId,
    required this.type,
    this.photoId,
    required this.identification,
    required this.nutrition,
    this.allergens = const [],
    this.improvementSuggestions = const [],
    required this.medicalAlerts,
    required this.suitableFor,
  });

  final String analysisId;
  final String type;
  final String? photoId;
  final IdentificationDto identification;
  final NutritionDto nutrition;
  final List<String> allergens;
  final List<String> improvementSuggestions;
  final MedicalAlertsDto medicalAlerts;
  final SuitableForDto suitableFor;

  factory AnalyzeResponseDto.fromJson(Map<String, dynamic> json) {
    return AnalyzeResponseDto(
      analysisId: json['analysisId'] as String,
      type: json['type'] as String,
      photoId: json['photoId'] as String?,
      identification: IdentificationDto.fromJson(json['identification'] as Map<String, dynamic>),
      nutrition: NutritionDto.fromJson(json['nutrition'] as Map<String, dynamic>),
      allergens: (json['allergens'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      improvementSuggestions: (json['improvementSuggestions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      medicalAlerts: MedicalAlertsDto.fromJson(json['medicalAlerts'] as Map<String, dynamic>),
      suitableFor: SuitableForDto.fromJson(json['suitableFor'] as Map<String, dynamic>),
    );
  }
}

class IdentificationDto {
  IdentificationDto({
    this.dishName,
    this.detectedIngredients = const [],
    this.estimatedPortionG,
  });

  final String? dishName;
  final List<String> detectedIngredients;
  final int? estimatedPortionG;

  factory IdentificationDto.fromJson(Map<String, dynamic> json) {
    return IdentificationDto(
      dishName: json['dishName'] as String?,
      detectedIngredients:
          (json['detectedIngredients'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      estimatedPortionG: json['estimatedPortionG'] as int?,
    );
  }
}

class NutritionDto {
  NutritionDto({
    this.calories,
    this.proteinsG,
    this.carbohydratesG,
    this.fatsG,
    this.fiberG,
  });

  final int? calories;
  final double? proteinsG;
  final double? carbohydratesG;
  final double? fatsG;
  final double? fiberG;

  factory NutritionDto.fromJson(Map<String, dynamic> json) {
    return NutritionDto(
      calories: json['calories'] as int?,
      proteinsG: (json['proteinsG'] as num?)?.toDouble(),
      carbohydratesG: (json['carbohydratesG'] as num?)?.toDouble(),
      fatsG: (json['fatsG'] as num?)?.toDouble(),
      fiberG: (json['fiberG'] as num?)?.toDouble(),
    );
  }
}

class MedicalAlertsDto {
  MedicalAlertsDto({
    this.diabetes,
    this.hypertension,
    this.cholesterol,
  });

  final String? diabetes;
  final String? hypertension;
  final String? cholesterol;

  factory MedicalAlertsDto.fromJson(Map<String, dynamic> json) {
    return MedicalAlertsDto(
      diabetes: json['diabetes'] as String?,
      hypertension: json['hypertension'] as String?,
      cholesterol: json['cholesterol'] as String?,
    );
  }
}

class SuitableForDto {
  SuitableForDto({
    this.children = false,
    this.lowFodmap = false,
    this.glutenFree = false,
    this.vegetarian = false,
    this.vegan = false,
  });

  final bool children;
  final bool lowFodmap;
  final bool glutenFree;
  final bool vegetarian;
  final bool vegan;

  factory SuitableForDto.fromJson(Map<String, dynamic> json) {
    return SuitableForDto(
      children: json['children'] as bool? ?? false,
      lowFodmap: json['lowFodmap'] as bool? ?? false,
      glutenFree: json['glutenFree'] as bool? ?? false,
      vegetarian: json['vegetarian'] as bool? ?? false,
      vegan: json['vegan'] as bool? ?? false,
    );
  }
}
