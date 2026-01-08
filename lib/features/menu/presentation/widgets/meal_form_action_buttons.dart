import 'package:flutter/material.dart';

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
        _OptionCard(
          icon: Icons.restaurant_menu,
          label: 'Mis recetas',
          description: 'Selecciona una comida de tu lista personal',
          color: Theme.of(context).colorScheme.primary,
          onPressed: onShowPresetRecipes,
        ),
        const SizedBox(height: 8),
        _OptionCard(
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

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
