import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Dropdown selector for meal type (lunch/dinner)
class MealTypeSelector extends StatelessWidget {
  const MealTypeSelector({
    required this.selectedMealType,
    required this.onChanged,
    super.key,
  });

  final MealType selectedMealType;
  final ValueChanged<MealType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MealType>(
      value: selectedMealType,
      decoration: const InputDecoration(
        labelText: 'Tipo de comida',
      ),
      items: MealType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
