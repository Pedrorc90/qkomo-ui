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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Seleccionar tipos de comidas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: MealType.values.map((mealType) {
                final isSelected = _selectedMealTypes[mealType] ?? false;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMealTypes[mealType] = !isSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedMealTypes[mealType] = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            mealType.displayName,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}
