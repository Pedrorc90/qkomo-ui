import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/menu/application/date_utils.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/custom_recipe_repository.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/deleted_preset_recipes_repository.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/weekly_menu_repository.dart';
import 'package:uuid/uuid.dart';

class MenuController extends StateNotifier<MenuState> {
  MenuController(
    this._repository, {
    required String Function() getUserId,
    CustomRecipeRepository? customRecipeRepository,
    DeletedPresetRecipesRepository? deletedPresetRecipesRepository,
    WeeklyMenuRepository? weeklyMenuRepository,
    Uuid? uuid,
  })  : _getUserId = getUserId,
        _customRecipeRepository = customRecipeRepository,
        _deletedPresetRecipesRepository = deletedPresetRecipesRepository,
        _weeklyMenuRepository = weeklyMenuRepository,
        _uuid = uuid ?? const Uuid(),
        super(MenuState());

  final MealRepository _repository; // Interface (can be Hybrid)
  final Uuid _uuid;
  final String Function() _getUserId;
  final CustomRecipeRepository? _customRecipeRepository;
  final DeletedPresetRecipesRepository? _deletedPresetRecipesRepository;
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
      final meal = Meal(
        id: _uuid.v4(),
        userId: userId,
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        scheduledFor: scheduledFor,
        createdAt: DateTime.now(),
        notes: notes,
        photoPath: photoPath,
        lastModifiedAt: DateTime.now(),
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
      await _customRecipeRepository.create(
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
        await _customRecipeRepository.delete(recipeId);
      } else {
        // Delete preset recipe by marking it as deleted
        if (_deletedPresetRecipesRepository == null) {
          state = state.copyWith(
            errorMessage: 'No se puede eliminar la receta en este momento',
          );
          return;
        }
        await _deletedPresetRecipesRepository.markAsDeleted(recipeId);
      }
      state = state.copyWith(clearError: true);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al eliminar la receta: $e',
      );
    }
  }

  // AI Weekly Menu methods

  void setSelectedDay(DateTime? day) {
    state = state.copyWith(selectedDay: day);
  }

  Future<void> loadAiWeekIfEnabled({DateTime? weekStart}) async {
    final effectiveWeekStart = weekStart ?? mondayOfWeek(DateTime.now());
    debugPrint('[MenuController] loadAiWeekIfEnabled() called for week: $effectiveWeekStart');

    if (_weeklyMenuRepository == null) {
      debugPrint('[MenuController] Missing weekly menu repository, aborting');
      return;
    }

    debugPrint('[MenuController] Current aiWeeklyMenu before load: ${state.aiWeeklyMenu != null ? "EXISTS" : "NULL"}');

    try {
      final weeklyMenu = await _weeklyMenuRepository.getWeek(effectiveWeekStart,
          userId: _getUserId());

      debugPrint(
          '[MenuController] Successfully loaded AI weekly menu for $effectiveWeekStart: ${weeklyMenu.days.length} days');
      state = state.copyWith(
        aiWeeklyMenu: weeklyMenu,
      );
      debugPrint('[MenuController] State updated, aiWeeklyMenu now: EXISTS');
    } on DioException catch (e) {
      // 404 means no menu generated yet -> empty AI state
      if (e.response?.statusCode == 404) {
        debugPrint(
            '[MenuController] 404 response for $effectiveWeekStart, clearing menu (was: ${state.aiWeeklyMenu != null ? "EXISTS" : "NULL"})');
        state = state.copyWith(
          clearAiWeeklyMenu: true,
        );
        debugPrint('[MenuController] State updated, aiWeeklyMenu now: ${state.aiWeeklyMenu != null ? "EXISTS" : "NULL"}');
      } else {
        debugPrint(
            '[MenuController] DioException (${e.response?.statusCode}): ${e.message}');
        state = state.copyWith(
          errorMessage: 'Error al cargar el menú semanal: ${e.message}',
        );
      }
    } catch (e) {
      debugPrint('[MenuController] Unexpected error: $e');
      state = state.copyWith(
        errorMessage: 'Error inesperado al cargar el menú semanal: $e',
      );
    }
  }

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
      final weeklyMenu = await _weeklyMenuRepository
          .generateWeek(effectiveWeekStart, userId: _getUserId());

      debugPrint('[MenuController] Generated weekly menu with ${weeklyMenu.days.length} days');
      for (final day in weeklyMenu.days) {
        debugPrint('[MenuController] Day ${day.date}: ${day.items.length} items');
        for (final item in day.items) {
          debugPrint('[MenuController]   - ${item.dishName} (${item.mealType}): imageUrl=${item.imageUrl}');
        }
      }

      state = state.copyWith(
        isLoading: false,
        aiWeeklyMenu: weeklyMenu,
      );
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
      final weeklyMenu = await _weeklyMenuRepository
          .regenerateDay(weekStart, date, userId: _getUserId());

      state = state.copyWith(
        isLoading: false,
        aiWeeklyMenu: weeklyMenu,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al regenerar el día: $e',
      );
    }
  }
}
