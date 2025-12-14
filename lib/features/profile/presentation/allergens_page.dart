import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/settings/application/settings_providers.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

class AllergensPage extends ConsumerWidget {
  const AllergensPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsProvider);

    return Scaffold(
      appBar: const QkomoNavBar(title: 'Mis Alérgenos'),
      body: settingsAsync.when(
        data: (settings) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: Allergen.values.length,
            itemBuilder: (context, index) {
              final allergen = Allergen.values[index];
              final isSelected = settings.allergens.contains(allergen);

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3)
                    : null,
                margin: const EdgeInsets.only(bottom: 8),
                child: SwitchListTile(
                  value: isSelected,
                  onChanged: (value) {
                    ref
                        .read(userSettingsProvider.notifier)
                        .toggleAllergen(allergen);
                  },
                  title: Text(
                    allergen.displayName,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  secondary: Icon(
                    Icons.warning_amber_rounded,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
