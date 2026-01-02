import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:uuid/uuid.dart';

/// Parameters for creating a meal
class CreateMealParams {
  const CreateMealParams({
    required this.userId,
    required this.name,
    required this.ingredients,
    required this.mealType,
    required this.scheduledFor,
    this.notes,
    this.photoPath,
  });

  final String userId;
  final String name;
  final List<String> ingredients;
  final MealType mealType;
  final DateTime scheduledFor;
  final String? notes;
  final String? photoPath;
}

/// UseCase: Create a new meal
///
/// Creates a meal with all required data and saves it to the repository.
class CreateMeal {
  CreateMeal(this._repository, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final MealRepository _repository;
  final Uuid _uuid;

  Future<Meal> call(CreateMealParams params) async {
    final now = DateTime.now();
    final meal = Meal(
      id: _uuid.v4(),
      userId: params.userId,
      name: params.name,
      ingredients: params.ingredients,
      mealType: params.mealType,
      scheduledFor: params.scheduledFor,
      createdAt: now,
      notes: params.notes,
      photoPath: params.photoPath,
      lastModifiedAt: now,
    );

    await _repository.saveMeal(meal);
    return meal;
  }
}
