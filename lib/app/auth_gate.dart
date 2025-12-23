import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:qkomo_ui/features/shell/presentation/root_shell.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize auth state check (non-blocking)
    // StreamProvider loads immediately but doesn't block - if user is authenticated,
    // RootShell will replace SignInPage seamlessly
    ref.watch(authStateChangesProvider);

    // Default to SignInPage while auth state is being determined
    // When user is authenticated, the watch will trigger a rebuild and show RootShell
    final authState = ref.watch(authStateChangesProvider);

    return authState.whenData((user) {
      // Only navigate to RootShell when we have confirmed the user is authenticated
      if (user != null) {
        return const RootShell();
      }
      // User is not authenticated or auth state is unknown
      return const SignInPage();
    }).when(
      data: (widget) => widget,
      loading: () => const SignInPage(), // Show SignInPage while determining auth state
      error: (error, _) => const SignInPage(), // Safe fallback to SignInPage on error
    );
  }
}
