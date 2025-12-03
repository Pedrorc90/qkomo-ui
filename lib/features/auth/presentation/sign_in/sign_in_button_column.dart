import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/auth/application/auth_controller.dart';

import 'auth_action_typedefs.dart';

class SignInButtonColumn extends StatelessWidget {
  const SignInButtonColumn({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.appleEnabled,
    required this.runAuthAction,
    required this.onEmailRequested,
  });

  final AuthController controller;
  final bool isLoading;
  final bool appleEnabled;
  final AuthActionRunner runAuthAction;
  final VoidCallback onEmailRequested;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Common button style
    final buttonStyle = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: isLoading
              ? null
              : () => runAuthAction(controller.signInWithGoogle),
          icon: const Icon(Icons.login),
          label: const Text('Continuar con Google'),
          style: buttonStyle,
        ),
        if (appleEnabled) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: isLoading
                ? null
                : () => runAuthAction(controller.signInWithApple),
            icon: const Icon(Icons.apple),
            label: const Text('Continuar con Apple'),
            style: buttonStyle,
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: Divider(color: scheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'o',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
            Expanded(child: Divider(color: scheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: isLoading ? null : onEmailRequested,
          icon: const Icon(Icons.mail_outline),
          label: const Text('Continuar con email'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            side: BorderSide(color: scheme.outline),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant.withOpacity(0.7),
                height: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
