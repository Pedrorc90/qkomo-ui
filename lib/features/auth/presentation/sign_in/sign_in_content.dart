import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/auth/application/auth_controller.dart';

import 'auth_action_typedefs.dart';
import 'sign_in_button_column.dart';
import 'sign_in_header.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SignInHeader(),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SignInButtonColumn(
                  controller: controller,
                  isLoading: isLoading,
                  appleEnabled: appleEnabled,
                  runAuthAction: runAuthAction,
                  onEmailRequested: onEmailRequested,
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
