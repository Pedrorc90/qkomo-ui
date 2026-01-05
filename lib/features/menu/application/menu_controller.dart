import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/menu/application/ai_weekly_menu_availability.dart';
import 'package:qkomo_ui/features/menu/application/date_utils.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';
import 'package:qkomo_ui/features/menu/data/exceptions/ai_weekly_menu_disabled_exception.dart';
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
    required bool Function() isAiWeeklyMenuEnabled,
    required String Function() getUserId,
    CustomRecipeRepository? customRecipeRepository,
    DeletedPresetRecipesRepository? deletedPresetRecipesRepository,
    WeeklyMenuRepository? weeklyMenuRepository,
    AiWeeklyMenuAvailability? aiAvailability,
    Uuid? uuid,
  })  : _isAiWeeklyMenuEnabled = isAiWeeklyMenuEnabled,
        _getUserId = getUserId,
        _customRecipeRepository = customRecipeRepository,
        _deletedPresetRecipesRepository = deletedPresetRecipesRepository,
        _weeklyMenuRepository = weeklyMenuRepository,
        _aiAvailability = aiAvailability,
        _uuid = uuid ?? const Uuid(),
        super(MenuState());

  final MealRepository _repository; // Interface (can be Hybrid)
  final Uuid _uuid;
  final bool Function() _isAiWeeklyMenuEnabled;
  final String Function() _getUserId;
  final CustomRecipeRepository? _customRecipeRepository;
  final DeletedPresetRecipesRepository? _deletedPresetRecipesRepository;
  final WeeklyMenuRepository? _weeklyMenuRepository;
  final AiWeeklyMenuAvailability? _aiAvailability;

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
    debugPrint('[MenuController] loadAiWeekIfEnabled() called');

    if (_weeklyMenuRepository == null || _aiAvailability == null) {
      debugPrint('[MenuController] Missing dependencies, aborting');
      return;
    }

    // Check feature toggle first (offline-first)
    final isEnabled = _isAiWeeklyMenuEnabled();
    debugPrint(
        '[MenuController] Feature toggle check: aiWeeklyMenuIsEnabled = $isEnabled');

    if (!isEnabled) {
      debugPrint(
          '[MenuController] Feature toggle disabled, setting aiDisabled=true');
      state = state.copyWith(aiDisabled: true, isAiModeActive: false);
      return;
    }

    if (_aiAvailability.isDisabled) {
      debugPrint(
          '[MenuController] AiWeeklyMenuAvailability disabled, setting aiDisabled=true');
      state = state.copyWith(aiDisabled: true, isAiModeActive: false);
      return;
    }

    debugPrint('[MenuController] Attempting to load AI weekly menu from API');

    try {
      final effectiveWeekStart = weekStart ?? mondayOfWeek(DateTime.now());
      final weeklyMenu = await _weeklyMenuRepository.getWeek(effectiveWeekStart,
          userId: _getUserId());

      debugPrint(
          '[MenuController] Successfully loaded AI weekly menu: ${weeklyMenu.days.length} days');
      state = state.copyWith(
        isAiModeActive: true,
        aiWeeklyMenu: weeklyMenu,
        aiDisabled: false,
      );
    } on AiWeeklyMenuDisabledException {
      debugPrint(
          '[MenuController] AiWeeklyMenuDisabledException caught, marking as disabled');
      _aiAvailability.markDisabled();
      state = state.copyWith(aiDisabled: true, isAiModeActive: false);
    } on DioException catch (e) {
      // 404 means no menu generated yet -> empty AI state
      if (e.response?.statusCode == 404) {
        debugPrint(
            '[MenuController] 404 response, no menu generated yet (empty AI state)');
        state = state.copyWith(
          isAiModeActive: true,
          clearAiWeeklyMenu: true,
          aiDisabled: false,
        );
      } else {
        debugPrint(
            '[MenuController] DioException (${e.response?.statusCode}): ${e.message}');
        // Other errors -> fallback to legacy
        state = state.copyWith(
          isAiModeActive: false,
          errorMessage: 'Error al cargar el menú semanal: ${e.message}',
        );
      }
    } catch (e) {
      debugPrint('[MenuController] Unexpected error: $e');
      state = state.copyWith(
        isAiModeActive: false,
        errorMessage: 'Error inesperado al cargar el menú semanal: $e',
      );
    }
  }

  Future<void> generateAiWeek({DateTime? weekStart}) async {
    if (_weeklyMenuRepository == null || _aiAvailability == null) {
      state = state.copyWith(
        errorMessage: 'El menú semanal AI no está disponible',
      );
      return;
    }

    // Check feature toggle first (offline-first)
    if (!_isAiWeeklyMenuEnabled()) {
      state = state.copyWith(
        aiDisabled: true,
        isAiModeActive: false,
        errorMessage: 'El menú semanal AI está deshabilitado',
      );
      return;
    }

    if (_aiAvailability.isDisabled) {
      state = state.copyWith(
        aiDisabled: true,
        isAiModeActive: false,
        errorMessage: 'El menú semanal AI está deshabilitado',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final effectiveWeekStart = weekStart ?? mondayOfWeek(DateTime.now());
      final weeklyMenu = await _weeklyMenuRepository
          .generateWeek(effectiveWeekStart, userId: _getUserId());

      state = state.copyWith(
        isLoading: false,
        isAiModeActive: true,
        aiWeeklyMenu: weeklyMenu,
        aiDisabled: false,
      );
    } on AiWeeklyMenuDisabledException {
      _aiAvailability.markDisabled();
      state = state.copyWith(
        isLoading: false,
        aiDisabled: true,
        isAiModeActive: false,
        errorMessage: 'El menú semanal AI está deshabilitado en el servidor',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al generar el menú semanal: $e',
      );
    }
  }

  Future<void> regenerateAiDay(DateTime date) async {
    if (_weeklyMenuRepository == null || _aiAvailability == null) {
      state = state.copyWith(
        errorMessage: 'El menú semanal AI no está disponible',
      );
      return;
    }

    // Check feature toggle first (offline-first)
    if (!_isAiWeeklyMenuEnabled()) {
      state = state.copyWith(
        aiDisabled: true,
        errorMessage: 'El menú semanal AI está deshabilitado',
      );
      return;
    }

    if (_aiAvailability.isDisabled) {
      state = state.copyWith(
        aiDisabled: true,
        errorMessage: 'El menú semanal AI está deshabilitado',
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
    } on AiWeeklyMenuDisabledException {
      _aiAvailability.markDisabled();
      state = state.copyWith(
        isLoading: false,
        aiDisabled: true,
        isAiModeActive: false,
        errorMessage: 'El menú semanal AI está deshabilitado en el servidor',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al regenerar el día: $e',
      );
    }
  }
}
