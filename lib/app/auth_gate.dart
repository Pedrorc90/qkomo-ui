import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:qkomo_ui/features/initialization/presentation/loading_screen.dart';
import 'package:qkomo_ui/features/shell/presentation/root_shell.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
      data: (user) => user == null ? const SignInPage() : const RootShell(),
      loading: () => const LoadingScreen(),
      error: (error, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error al iniciar Firebase Auth: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
