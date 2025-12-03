import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/auth/application/auth_controller.dart';

import 'package:qkomo_ui/features/auth/presentation/sign_in/auth_action_typedefs.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/sign_in_button_column.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/sign_in_header.dart';

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
        const SizedBox(height: 48),
        SignInButtonColumn(
          controller: controller,
          isLoading: isLoading,
          appleEnabled: appleEnabled,
          runAuthAction: runAuthAction,
          onEmailRequested: onEmailRequested,
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
