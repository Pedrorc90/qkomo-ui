import '../domain/meal.dart';

class MenuState {
  final bool isLoading;
  final String? errorMessage;
  final Meal? editingMeal;

  MenuState({
    this.isLoading = false,
    this.errorMessage,
    this.editingMeal,
  });

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
