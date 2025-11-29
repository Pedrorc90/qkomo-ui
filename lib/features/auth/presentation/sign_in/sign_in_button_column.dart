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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: isLoading ? null : () => runAuthAction(controller.signInWithGoogle),
          icon: const Icon(Icons.login),
          label: const Text('Continuar con Google'),
        ),
        if (appleEnabled) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: isLoading ? null : () => runAuthAction(controller.signInWithApple),
            icon: const Icon(Icons.apple),
            label: const Text('Continuar con Apple'),
          ),
        ],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isLoading ? null : onEmailRequested,
          icon: const Icon(Icons.mail_outline),
          label: const Text('Continuar con email'),
        ),
        const SizedBox(height: 16),
        Text(
          'Usamos tu cuenta para sincronizar tus capturas con la IA. Puedes cerrar sesión en cualquier momento.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
