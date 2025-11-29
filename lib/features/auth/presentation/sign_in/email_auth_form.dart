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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Contraseña'),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onToggleMode,
            child:
                Text(mode == EmailAuthMode.signIn ? '¿Necesitas registrarte?' : '¿Ya tienes cuenta?'),
          ),
        )
      ],
    );
  }
}
