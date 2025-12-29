import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class UserRecipe {
  UserRecipe({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredients,
    required this.mealType,
    required this.createdAt,
    this.photoPath,
  });

  final String id;
  final String userId;
  final String name;
  final List<String> ingredients;
  final MealType mealType;
  final DateTime createdAt;
  final String? photoPath;

  UserRecipe copyWith({
    String? id,
    String? userId,
    String? name,
    List<String>? ingredients,
    MealType? mealType,
    DateTime? createdAt,
    String? photoPath,
  }) {
    return UserRecipe(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      mealType: mealType ?? this.mealType,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
