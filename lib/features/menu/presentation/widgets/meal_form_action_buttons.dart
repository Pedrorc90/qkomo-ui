import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/capture_option_card.dart';

class MealFormActionButtons extends StatelessWidget {
  const MealFormActionButtons({
    super.key,
    required this.onShowPresetRecipes,
    required this.onCreateCustom,
  });

  final VoidCallback onShowPresetRecipes;
  final VoidCallback onCreateCustom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CaptureOptionCard(
          icon: Icons.restaurant_menu,
          label: 'Mis recetas',
          description: 'Selecciona una comida de tu lista personal',
          color: Theme.of(context).colorScheme.primary,
          onPressed: onShowPresetRecipes,
        ),
        const SizedBox(height: 8),
        CaptureOptionCard(
          icon: Icons.add_circle_outline,
          label: 'Crear nueva',
          description: 'Añade una comida personalizada manualmente',
          color: Theme.of(context).colorScheme.secondary,
          onPressed: onCreateCustom,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
