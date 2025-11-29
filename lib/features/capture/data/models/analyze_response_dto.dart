class AnalyzeResponseDto {
  AnalyzeResponseDto({
    required this.analysisId,
    required this.type,
    this.photoId,
    required this.ingredients,
    this.warnings = const [],
  });

  final String analysisId;
  final String type;
  final String? photoId;
  final List<IngredientDto> ingredients;
  final List<String> warnings;

  factory AnalyzeResponseDto.fromJson(Map<String, dynamic> json) {
    return AnalyzeResponseDto(
      analysisId: json['analysisId'] as String,
      type: json['type'] as String,
      photoId: json['photoId'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((item) => IngredientDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      warnings:
          (json['warnings'] as List<dynamic>? ?? []).map((w) => w.toString()).toList(),
    );
  }
}

class IngredientDto {
  IngredientDto({
    required this.name,
    this.confidence,
    this.allergens = const [],
  });

  final String name;
  final double? confidence;
  final List<String> allergens;

  factory IngredientDto.fromJson(Map<String, dynamic> json) {
    return IngredientDto(
      name: json['name'] as String,
      confidence: (json['confidence'] as num?)?.toDouble(),
      allergens:
          (json['allergens'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
