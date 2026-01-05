import 'package:qkomo_ui/features/menu/data/models/weekly_meal_type.dart';

class WeeklyMenuItemDto {
  WeeklyMenuItemDto({
    required this.mealType,
    required this.dishName,
    this.description,
    required this.ingredients,
    this.imageUrl,
    required this.constraintsOk,
    this.violations,
  });

  final WeeklyMealType mealType;
  final String dishName;
  final String? description;
  final List<String> ingredients;
  final String? imageUrl;
  final bool constraintsOk;
  final List<String>? violations;

  factory WeeklyMenuItemDto.fromJson(Map<String, dynamic> json) {
    return WeeklyMenuItemDto(
      mealType: WeeklyMealType.parse(json['mealType'] as String?),
      dishName: json['dishName'] as String? ?? '',
      description: json['description'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
      constraintsOk: json['constraintsOk'] as bool? ?? true,
      violations: (json['violations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealType': mealType.toJson(),
      'dishName': dishName,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'constraintsOk': constraintsOk,
      'violations': violations,
    };
  }
}
