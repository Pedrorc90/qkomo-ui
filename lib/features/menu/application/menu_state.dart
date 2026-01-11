import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_item.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';

class MenuState {
  MenuState({
    this.isLoading = false,
    this.errorMessage,
    this.editingMeal,
    this.aiWeeklyMenu,
    this.selectedDay,
  });

  final bool isLoading;
  final String? errorMessage;
  final Meal? editingMeal;

  // AI weekly menu fields
  final WeeklyMenu? aiWeeklyMenu;
  final DateTime? selectedDay;

  List<WeeklyMenuItem> selectedDayAiItems() {
    if (aiWeeklyMenu == null || selectedDay == null) return [];

    final day = aiWeeklyMenu!.days.where((d) {
      return d.date.year == selectedDay!.year &&
          d.date.month == selectedDay!.month &&
          d.date.day == selectedDay!.day;
    }).firstOrNull;

    return day?.items ?? [];
  }

  bool get showAiGenerateCta => aiWeeklyMenu == null;

  MenuState copyWith({
    bool? isLoading,
    String? errorMessage,
    Meal? editingMeal,
    bool clearError = false,
    bool clearEditing = false,
    WeeklyMenu? aiWeeklyMenu,
    DateTime? selectedDay,
    bool clearAiWeeklyMenu = false,
  }) {
    return MenuState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      editingMeal: clearEditing ? null : (editingMeal ?? this.editingMeal),
      aiWeeklyMenu:
          clearAiWeeklyMenu ? null : (aiWeeklyMenu ?? this.aiWeeklyMenu),
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}
