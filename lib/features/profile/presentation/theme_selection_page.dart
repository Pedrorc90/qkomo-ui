import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

class ThemeSelectionPage extends ConsumerWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeTypeProvider);

    return Scaffold(
      appBar: const QkomoNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Original themes
                    _ThemeOption(
                      label: 'Cálido',
                      description: 'Naranja cálido e invitador',
                      isSelected: currentTheme == AppThemeType.warm,
                      color: const Color(0xFFFF6F3C),
                      onTap: () => ref.read(themeTypeProvider.notifier).state =
                          AppThemeType.warm,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Off-White',
                      description: 'Gris minimalista neutral',
                      isSelected: currentTheme == AppThemeType.offWhite,
                      color: const Color(0xFF5D5D5D),
                      onTap: () => ref.read(themeTypeProvider.notifier).state =
                          AppThemeType.offWhite,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Oscuro',
                      description: 'Azul oscuro para modo noche',
                      isSelected: currentTheme == AppThemeType.dark,
                      color: const Color(0xFF3B82F6),
                      onTap: () => ref.read(themeTypeProvider.notifier).state =
                          AppThemeType.dark,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Bosque',
                      description: 'Verde bosque natural',
                      isSelected: currentTheme == AppThemeType.forest,
                      color: const Color(0xFF2D5016),
                      onTap: () => ref.read(themeTypeProvider.notifier).state =
                          AppThemeType.forest,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Índigo',
                      description: 'Índigo profundo y elegante',
                      isSelected: currentTheme == AppThemeType.indigo,
                      color: const Color(0xFF4338CA),
                      onTap: () => ref.read(themeTypeProvider.notifier).state =
                          AppThemeType.indigo,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(51),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withAlpha(153),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: Theme.of(context).colorScheme.outlineVariant,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
