import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Header section for meal form dialog with back button and title
class MealFormHeader extends StatelessWidget {
  const MealFormHeader({
    required this.isEditing,
    required this.selectedMealType,
    required this.showingForm,
    required this.onBack,
    super.key,
  });

  final bool isEditing;
  final MealType selectedMealType;
  final bool showingForm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
              child: Text(
                isEditing
                    ? 'Editar ${selectedMealType.displayName}'
                    : 'Agregar comida',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
