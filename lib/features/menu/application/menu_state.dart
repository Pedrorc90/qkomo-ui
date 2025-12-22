import 'package:qkomo_ui/features/menu/domain/meal.dart';

class MenuState {
  MenuState({
    this.isLoading = false,
    this.errorMessage,
    this.editingMeal,
  });
  final bool isLoading;
  final String? errorMessage;
  final Meal? editingMeal;

  MenuState copyWith({
    bool? isLoading,
    String? errorMessage,
    Meal? editingMeal,
    bool clearError = false,
    bool clearEditing = false,
  }) {
    return MenuState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      editingMeal: clearEditing ? null : (editingMeal ?? this.editingMeal),
    );
  }
}
