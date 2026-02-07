import 'package:flutter/material.dart';

/// Empty state widget for weekly menu section
class WeeklyMenuEmptyState extends StatelessWidget {
  const WeeklyMenuEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: colorScheme.primary.withAlpha((0.7 * 255).round()),
            ),
            const SizedBox(height: 12),
            Text(
              'Aún no tienes un menú semanal',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Genéralo en un solo paso con IA',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
