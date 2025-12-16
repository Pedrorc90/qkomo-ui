import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickActionsPanel extends ConsumerWidget {
  const QuickActionsPanel({
    super.key,
    required this.selectedDay,
  });

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerLow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                'Acciones rápidas',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            Row(
              children: [
                // Copy previous day
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.content_copy,
                    label: 'Copiar día\nanterior',
                    onPressed: () => _copyPreviousDay(context, ref),
                  ),
                ),
                const SizedBox(width: 8),
                // Clear day
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.delete_sweep,
                    label: 'Limpiar\ncomidas',
                    onPressed: () => _clearDayMeals(context, ref),
                  ),
                ),
                const SizedBox(width: 8),
                // Swap meals
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.swap_horiz,
                    label: 'Intercambiar\ncomidas',
                    onPressed: () => _swapMeals(context),
                  ),
                ),
                const SizedBox(width: 8),
                // Suggestions
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.lightbulb_outline,
                    label: 'Sugerencias\nIA',
                    onPressed: () => _generateSuggestions(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyPreviousDay(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Función de copiar día anterior será implementada en la próxima versión'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearDayMeals(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Limpiar comidas'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar todas las comidas para este día?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función será implementada en la próxima versión'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _swapMeals(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Función de intercambiar comidas será implementada en la próxima versión'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateSuggestions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Función de sugerencias con IA será implementada en la próxima versión'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
