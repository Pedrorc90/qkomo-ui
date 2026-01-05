import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_item.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';

class MenuState {
  MenuState({
    this.isLoading = false,
    this.errorMessage,
    this.editingMeal,
    this.isAiModeActive = false,
    this.aiWeeklyMenu,
    this.aiDisabled = false,
    this.selectedDay,
  });

  final bool isLoading;
  final String? errorMessage;
  final Meal? editingMeal;

  // AI weekly menu fields
  final bool isAiModeActive;
  final WeeklyMenu? aiWeeklyMenu;
  final bool aiDisabled;
  final DateTime? selectedDay;

  // Helpers
  bool get canManualEdit => !isAiModeActive;

  List<WeeklyMenuItem> selectedDayAiItems() {
    if (aiWeeklyMenu == null || selectedDay == null) return [];

    final day = aiWeeklyMenu!.days.where((d) {
      return d.date.year == selectedDay!.year &&
          d.date.month == selectedDay!.month &&
          d.date.day == selectedDay!.day;
    }).firstOrNull;

    return day?.items ?? [];
  }

  bool get showAiGenerateCta => isAiModeActive && aiWeeklyMenu == null;

  MenuState copyWith({
    bool? isLoading,
    String? errorMessage,
    Meal? editingMeal,
    bool clearError = false,
    bool clearEditing = false,
    bool? isAiModeActive,
    WeeklyMenu? aiWeeklyMenu,
    bool? aiDisabled,
    DateTime? selectedDay,
    bool clearAiWeeklyMenu = false,
  }) {
    return MenuState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      editingMeal: clearEditing ? null : (editingMeal ?? this.editingMeal),
      isAiModeActive: isAiModeActive ?? this.isAiModeActive,
      aiWeeklyMenu:
          clearAiWeeklyMenu ? null : (aiWeeklyMenu ?? this.aiWeeklyMenu),
      aiDisabled: aiDisabled ?? this.aiDisabled,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}
