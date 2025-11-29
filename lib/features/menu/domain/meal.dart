import 'meal_type.dart';

class Meal {
  final String id;
  final String name;
  final List<String> ingredients;
  final MealType mealType;
  final DateTime scheduledFor;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;

  Meal({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.mealType,
    required this.scheduledFor,
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  Meal copyWith({
    String? id,
    String? name,
    List<String>? ingredients,
    MealType? mealType,
    DateTime? scheduledFor,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      mealType: mealType ?? this.mealType,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }
}
