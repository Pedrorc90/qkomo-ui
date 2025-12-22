import 'package:flutter/material.dart';

/// Common allergens in Spanish
const commonAllergens = [
  'Gluten',
  'Lactosa',
  'Huevo',
  'Frutos secos',
  'Soja',
  'Pescado',
  'Mariscos',
  'Cacahuetes',
  'Sésamo',
  'Sulfitos',
  'Apio',
  'Mostaza',
];

/// Widget for toggling allergens on/off
class AllergenToggleList extends StatelessWidget {
  const AllergenToggleList({
    super.key,
    required this.selectedAllergens,
    required this.onToggle,
  });

  final List<String> selectedAllergens;
  final Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alérgenos detectados',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),

        if (selectedAllergens.isEmpty)
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No se detectaron alérgenos.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox.shrink(),

        const SizedBox(height: 8),

        // Allergen toggles
        ...commonAllergens.map((allergen) {
          final isSelected = selectedAllergens.contains(allergen);

          return Card(
            color: isSelected
                ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
                : null,
            child: SwitchListTile(
              value: isSelected,
              onChanged: (_) => onToggle(allergen),
              title: Text(
                allergen,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected ? Theme.of(context).colorScheme.error : null,
                ),
              ),
              secondary: Icon(
                isSelected ? Icons.warning : Icons.check_circle_outline,
                color: isSelected
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }),

        const SizedBox(height: 8),
        Text(
          'Activa los alérgenos presentes en este producto',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
