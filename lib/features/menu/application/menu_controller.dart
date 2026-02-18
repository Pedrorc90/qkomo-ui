import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/menu/application/date_utils.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/domain/usecases/create_meal.dart';
import 'package:qkomo_ui/features/menu/domain/usecases/delete_meal.dart';
import 'package:qkomo_ui/features/menu/domain/usecases/delete_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/usecases/save_meal_as_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/usecases/update_meal.dart';

class MenuController extends StateNotifier<MenuState> {
  MenuController({
    required CreateMeal createMeal,
    required UpdateMeal updateMeal,
    required DeleteMeal deleteMeal,
    required SaveMealAsRecipe saveMealAsRecipe,
    required DeleteRecipe deleteRecipe,
    required MealRepository repository,
    required String Function() getUserId,
    WeeklyMenuRepository? weeklyMenuRepository,
  })  : _createMeal = createMeal,
        _updateMeal = updateMeal,
        _deleteMeal = deleteMeal,
        _saveMealAsRecipe = saveMealAsRecipe,
        _deleteRecipe = deleteRecipe,
        _repository = repository,
        _getUserId = getUserId,
        _weeklyMenuRepository = weeklyMenuRepository,
        super(MenuState());

  final CreateMeal _createMeal;
  final UpdateMeal _updateMeal;
  final DeleteMeal _deleteMeal;
  final SaveMealAsRecipe _saveMealAsRecipe;
  final DeleteRecipe _deleteRecipe;
  final MealRepository _repository;
  final String Function() _getUserId;
  final WeeklyMenuRepository? _weeklyMenuRepository;

  Future<void> createMeal({
    required String userId,
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    required DateTime scheduledFor,
    String? notes,
    String? photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _createMeal(CreateMealParams(
        userId: userId,
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        scheduledFor: scheduledFor,
        notes: notes,
        photoPath: photoPath,
      ));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al crear la comida: $e',
      );
    }
  }

  Future<void> updateMeal({
    required String id,
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    required DateTime scheduledFor,
    String? notes,
    String? photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _updateMeal(UpdateMealParams(
        id: id,
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        scheduledFor: scheduledFor,
        notes: notes,
        photoPath: photoPath,
      ));
      state = state.copyWith(isLoading: false, clearEditing: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al actualizar la comida: $e',
      );
    }
  }

  Future<void> deleteMeal(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _deleteMeal(id);
      state = state.copyWith(isLoading: false, clearEditing: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al eliminar la comida: $e',
      );
    }
  }

  Future<void> deleteMealsForDay(DateTime date) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get meals for that day and delete each one
      final meals = await _repository.getMeals(from: date, to: date);
      for (final meal in meals) {
        await _deleteMeal(meal.id);
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al eliminar las comidas del día: $e',
      );
    }
  }

  void startEditing(Meal meal) {
    state = state.copyWith(editingMeal: meal);
  }

  void cancelEditing() {
    state = state.copyWith(clearEditing: true);
  }

  Future<void> saveAsRecipe({
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    String? photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _saveMealAsRecipe(SaveMealAsRecipeParams(
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        photoPath: photoPath,
      ));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar la receta: $e',
      );
    }
  }

  Future<void> deleteRecipe(String recipeId, {bool isCustom = true}) async {
    try {
      await _deleteRecipe(recipeId: recipeId, isCustom: isCustom);
      state = state.copyWith(clearError: true);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al eliminar la receta: $e',
      );
    }
  }

  // AI Weekly Menu methods

  Future<void> generateAiWeek({DateTime? weekStart}) async {
    if (_weeklyMenuRepository == null) {
      state = state.copyWith(
        errorMessage: 'El menú semanal AI no está disponible',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final effectiveWeekStart = weekStart ?? mondayOfWeek(DateTime.now());
      await _weeklyMenuRepository
          .generateWeek(effectiveWeekStart, userId: _getUserId());

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al generar el menú semanal: $e',
      );
    }
  }

  Future<void> regenerateAiDay(DateTime date) async {
    if (_weeklyMenuRepository == null) {
      state = state.copyWith(
        errorMessage: 'El menú semanal AI no está disponible',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final weekStart = mondayOfWeek(date);
      await _weeklyMenuRepository
          .regenerateDay(weekStart, date, userId: _getUserId());

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al regenerar el día: $e',
      );
    }
  }
}
