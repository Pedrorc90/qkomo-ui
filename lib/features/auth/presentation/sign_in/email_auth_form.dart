import 'package:flutter/material.dart';

import 'email_auth_result.dart';

class EmailAuthForm extends StatelessWidget {
  const EmailAuthForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.mode,
    required this.onToggleMode,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final EmailAuthMode mode;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: scheme.surfaceVariant.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration.copyWith(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: inputDecoration.copyWith(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: onToggleMode,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              foregroundColor: scheme.secondary,
            ),
            child: Text(
              mode == EmailAuthMode.signIn
                  ? '¿No tienes cuenta? Regístrate'
                  : '¿Ya tienes cuenta? Inicia sesión',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
