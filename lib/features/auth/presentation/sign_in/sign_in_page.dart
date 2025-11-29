import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/auth/domain/auth_failure.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

import 'auth_action_typedefs.dart';
import 'email_auth_dialog.dart';
import 'email_auth_result.dart';
import 'sign_in_content.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider);
    final isLoading = ref.watch(authInProgressProvider);
    final gradient = ref.watch(appGradientProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SignInContent(
                  controller: controller,
                  isLoading: isLoading,
                  appleEnabled: _appleSignInAvailable,
                  runAuthAction: (action) => _runAuthAction(context, ref, action),
                  onEmailRequested: () => _promptEmailSignIn(context, ref, controller),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static bool get _appleSignInAvailable {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  Future<void> _runAuthAction(BuildContext context, WidgetRef ref, AuthAction action) async {
    final progress = ref.read(authInProgressProvider.notifier);
    if (progress.state) return;
    progress.state = true;
    try {
      await action();
    } on AuthFailure catch (e) {
      _showError(context, e.message);
    } catch (e) {
      _showError(context, 'Ocurrió un error inesperado ($e)');
    } finally {
      progress.state = false;
    }
  }

  Future<void> _promptEmailSignIn(
    BuildContext context,
    WidgetRef ref,
    AuthController controller,
  ) async {
    final result = await showDialog<EmailAuthResult>(
      context: context,
      builder: (context) => const EmailAuthDialog(),
    );
    if (result == null) return;
    await _runAuthAction(context, ref, () {
      return controller.signInWithEmail(
        result.email,
        result.password,
        register: result.mode == EmailAuthMode.register,
      );
    });
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
