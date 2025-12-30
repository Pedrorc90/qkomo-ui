import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/allergen_badge.dart';
import 'package:qkomo_ui/features/settings/application/settings_providers.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// List of common allergens in Spanish
const commonAllergenNames = [
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
  'Altramuces',
  'Moluscos',
];

/// Mapper between allergen display names (string) and enum Allergen
Allergen? allergenFromDisplayName(String displayName) {
  for (final allergen in Allergen.values) {
    if (allergen.displayName == displayName) {
      return allergen;
    }
  }
  return null;
}

/// Allergen selector with personal alerts integration
class AllergenSelector extends ConsumerWidget {
  const AllergenSelector({
    super.key,
    required this.selectedAllergens,
    required this.onToggle,
  });

  final List<String> selectedAllergens;
  final Function(String) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingsAsync = ref.watch(userSettingsProvider);

    return userSettingsAsync.when(
      data: (settings) => _buildContent(context, settings),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _buildContent(context, const UserSettings()),
    );
  }

  Widget _buildContent(BuildContext context, UserSettings settings) {
    // Separate detected allergens into personal and others
    final personalAllergens = <String>[];
    final otherDetectedAllergens = <String>[];

    for (final allergenName in selectedAllergens) {
      final allergenEnum = allergenFromDisplayName(allergenName);
      if (allergenEnum != null && settings.allergens.contains(allergenEnum)) {
        personalAllergens.add(allergenName);
      } else {
        otherDetectedAllergens.add(allergenName);
      }
    }

    // Common allergens not detected
    final undetectedAllergens = commonAllergenNames
        .where((name) => !selectedAllergens.contains(name))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alérgenos detectados',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),

        // Section of personal alerts (if any)
        if (personalAllergens.isNotEmpty) ...[
          _buildPersonalAlertsSection(context, personalAllergens),
          const SizedBox(height: 16),
        ],

        // Other detected allergens
        if (otherDetectedAllergens.isNotEmpty) ...[
          _buildDetectedSection(context, otherDetectedAllergens),
          const SizedBox(height: 16),
        ],

        // Empty state if no allergens detected
        if (selectedAllergens.isEmpty) ...[
          _buildEmptyState(context),
          const SizedBox(height: 16),
        ],

        // Section of common allergens (toggleable)
        _buildCommonAllergensSection(context, undetectedAllergens),
      ],
    );
  }

  Widget _buildPersonalAlertsSection(
    BuildContext context,
    List<String> personalAllergens,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: scheme.error,
          width: DesignTokens.borderWidthMedium,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: scheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Alerta personal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.error,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: personalAllergens.map((allergen) {
              return AllergenBadge(
                allergen: allergen,
                isPersonalAlert: true,
                onTap: () => onToggle(allergen),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedSection(
    BuildContext context,
    List<String> allergens,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Otros alérgenos detectados',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergens.map((allergen) {
            return AllergenBadge(
              allergen: allergen,
              onTap: () => onToggle(allergen),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: scheme.primary,
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
    );
  }

  Widget _buildCommonAllergensSection(
    BuildContext context,
    List<String> undetectedAllergens,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alérgenos comunes',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Toca para añadir si están presentes',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: undetectedAllergens.map((allergen) {
            return ActionChip(
              label: Text(allergen),
              avatar: Icon(
                Icons.add_circle_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => onToggle(allergen),
            );
          }).toList(),
        ),
      ],
    );
  }
}
