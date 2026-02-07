import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Horizontal filter chips for meal type selection
class RecipeFilterChips extends StatelessWidget {
  const RecipeFilterChips({
    required this.selectedMealType,
    required this.onMealTypeSelected,
    super.key,
  });

  final MealType? selectedMealType;
  final ValueChanged<MealType?> onMealTypeSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (MealType.lunch, 'Comida'),
              (MealType.dinner, 'Cena'),
            ].map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter.$2),
                  selected: selectedMealType == filter.$1,
                  onSelected: (selected) {
                    onMealTypeSelected(selected ? filter.$1 : null);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
