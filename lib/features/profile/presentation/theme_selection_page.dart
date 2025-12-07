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
                    _ThemeOption(
                      label: 'Cálido',
                      isSelected: currentTheme == AppThemeType.warm,
                      color: const Color(0xFFFF6F3C), // Seed color from Warm
                      onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.warm,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Fresco',
                      isSelected: currentTheme == AppThemeType.fresh,
                      color: const Color(0xFF2DD4BF), // Seed color from Fresh
                      onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.fresh,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Off-White',
                      isSelected: currentTheme == AppThemeType.offWhite,
                      color: const Color(0xFF5D5D5D), // Seed color from OffWhite
                      onTap: () =>
                          ref.read(themeTypeProvider.notifier).state = AppThemeType.offWhite,
                    ),
                    const Divider(),
                    _ThemeOption(
                      label: 'Oscuro',
                      isSelected: currentTheme == AppThemeType.dark,
                      color: const Color(0xFF3B82F6), // Seed color from Dark
                      onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.dark,
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
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
