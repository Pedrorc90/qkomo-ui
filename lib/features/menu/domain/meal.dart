import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class Meal {
  final String id;
  final String userId;
  final String name;
  final List<String> ingredients;
  final MealType mealType;
  final DateTime scheduledFor;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final String? photoPath; // Path to local image or asset

  Meal({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredients,
    required this.mealType,
    required this.scheduledFor,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.photoPath,
  });

  Meal copyWith({
    String? id,
    String? userId,
    String? name,
    List<String>? ingredients,
    MealType? mealType,
    DateTime? scheduledFor,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    String? photoPath,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      mealType: mealType ?? this.mealType,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
