import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_content.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_header.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final gradient = ref.watch(appGradientProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Column(
            children: [
              // Qkomo NavBar
              const QkomoNavBar(),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Home header with next meal image or hero capture button
                      HomeHeader(user: user),
                      const SizedBox(height: DesignTokens.spacingLg),

                      // Recent entries and upcoming meals
                      HomeContent(user: user),
                      const SizedBox(height: 80), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
