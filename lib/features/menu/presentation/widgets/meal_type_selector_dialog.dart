import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class MealTypeSelectorDialog extends StatefulWidget {
  const MealTypeSelectorDialog({super.key});

  @override
  State<MealTypeSelectorDialog> createState() => _MealTypeSelectorDialogState();
}

class _MealTypeSelectorDialogState extends State<MealTypeSelectorDialog> {
  final Map<MealType, bool> _selectedMealTypes = {
    MealType.breakfast: false,
    MealType.lunch: true,
    MealType.snack: false,
    MealType.dinner: true,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar tipos de comidas'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: MealType.values.map((mealType) {
            return CheckboxListTile(
              title: Text(mealType.displayName),
              value: _selectedMealTypes[mealType] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  _selectedMealTypes[mealType] = value ?? false;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final selected =
                _selectedMealTypes.entries.where((e) => e.value).map((e) => e.key).toList();

            if (selected.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Debes seleccionar al menos un tipo de comida'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            Navigator.of(context).pop(selected);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
