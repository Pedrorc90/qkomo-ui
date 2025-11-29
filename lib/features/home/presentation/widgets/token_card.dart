import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenCard extends StatelessWidget {
  const TokenCard({super.key, required this.token});

  final AsyncValue<String?> token;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.vpn_key_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Token Firebase (ID)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: token.when(
                data: (value) => SelectableText(
                  value ?? 'No disponible (actualiza arriba)',
                  maxLines: 4,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                loading: () => const Text('Leyendo token...'),
                error: (error, _) => Text('Error al leer token: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
