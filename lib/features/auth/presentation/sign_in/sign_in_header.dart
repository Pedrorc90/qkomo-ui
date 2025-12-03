import 'package:flutter/material.dart';

import 'package:qkomo_ui/core/widgets/qkomo_logo.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const QkomoLogo(size: 80),
        const SizedBox(height: 24),
        Text(
          'qkomo',
          style: textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tu copiloto nutricional',
          style: textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Captura ingredientes, analiza etiquetas y entiende lo que comes con IA.',
            style: textTheme.bodyLarge?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
