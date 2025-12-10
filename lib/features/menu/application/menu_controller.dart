import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/menu/data/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';

class MenuController extends StateNotifier<MenuState> {
  MenuController(this._repository) : super(MenuState());

  final MealRepository _repository;

  Future<void> createMeal({
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    required DateTime scheduledFor,
    String? notes,
    String? photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.create(
        name: name,
        ingredients: ingredients,
        mealType: mealType,
        scheduledFor: scheduledFor,
        notes: notes,
        photoPath: photoPath,
      );
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
      final existing = _repository.getById(id);
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
        notes: notes,
        photoPath: photoPath,
      );

      await _repository.update(id, updatedMeal);
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
      await _repository.delete(id);
      state = state.copyWith(isLoading: false, clearEditing: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al eliminar la comida: $e',
      );
    }
  }

  void startEditing(Meal meal) {
    state = state.copyWith(editingMeal: meal);
  }

  void cancelEditing() {
    state = state.copyWith(clearEditing: true);
  }
}
