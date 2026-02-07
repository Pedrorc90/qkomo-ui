import 'package:flutter/material.dart';

/// Confirmation dialog for removing a companion
class RemoveCompanionDialog extends StatelessWidget {
  const RemoveCompanionDialog({
    required this.companionName,
    super.key,
  });

  final String companionName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Desvincular compañero',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '¿Seguro que quieres eliminar a $companionName? Dejarán de compartir el menú semanal.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Desvincular'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
