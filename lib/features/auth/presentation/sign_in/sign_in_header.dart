import 'package:flutter/material.dart';

import 'package:qkomo_ui/core/widgets/qkomo_logo.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const QkomoLogo(size: 56),
            const SizedBox(width: 16),
            Text(
              'qkomo',
              style: textTheme.displaySmall
                  ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Tu copiloto para leer etiquetas y entender lo que comes.',
          style: textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
