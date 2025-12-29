import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';
import 'package:qkomo_ui/features/menu/data/custom_recipe_repository.dart';
import 'package:qkomo_ui/features/menu/data/deleted_preset_recipes_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:uuid/uuid.dart';

class MenuController extends StateNotifier<MenuState> {
  MenuController(
    this._repository, {
    CustomRecipeRepository? customRecipeRepository,
    DeletedPresetRecipesRepository? deletedPresetRecipesRepository,
    Uuid? uuid,
  })  : _customRecipeRepository = customRecipeRepository,
        _deletedPresetRecipesRepository = deletedPresetRecipesRepository,
        _uuid = uuid ?? const Uuid(),
        super(MenuState());

  final MealRepository _repository; // Interface (can be Hybrid)
  final Uuid _uuid;
  final CustomRecipeRepository? _customRecipeRepository;
  final DeletedPresetRecipesRepository? _deletedPresetRecipesRepository;

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
      final meal = Meal(
        id: _uuid.v4(),
        userId: userId,
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        scheduledFor: scheduledFor,
        createdAt: DateTime.now(),
        updatedAt: null,
        notes: notes,
        photoPath: photoPath,
        // Sync fields with defaults
        syncStatus: SyncStatus.pending,
        lastModifiedAt: DateTime.now(),
        lastSyncedAt: null,
        isDeleted: false,
        cloudVersion: null,
        pendingChanges: null,
      );

      await _repository.saveMeal(meal);
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
      final existing = await _repository.getMealById(id);
      if (existing == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Comida no encontrada',
        );
        return;
      }

      final updatedMeal = existing.copyWith(
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        scheduledFor: scheduledFor,
        updatedAt: DateTime.now(),
        notes: notes,
        photoPath: photoPath,
      );

      await _repository.saveMeal(updatedMeal);
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
      await _repository.deleteMeal(id);
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
        await _repository.deleteMeal(meal.id);
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
    if (_customRecipeRepository == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se puede guardar la receta en este momento',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _customRecipeRepository!.create(
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        photoPath: photoPath,
      );
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
      if (isCustom) {
        if (_customRecipeRepository == null) {
          state = state.copyWith(
            errorMessage: 'No se puede eliminar la receta en este momento',
          );
          return;
        }
        await _customRecipeRepository!.delete(recipeId);
      } else {
        // Delete preset recipe by marking it as deleted
        if (_deletedPresetRecipesRepository == null) {
          state = state.copyWith(
            errorMessage: 'No se puede eliminar la receta en este momento',
          );
          return;
        }
        await _deletedPresetRecipesRepository!.markAsDeleted(recipeId);
      }
      state = state.copyWith(clearError: true);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al eliminar la receta: $e',
      );
    }
  }
}
