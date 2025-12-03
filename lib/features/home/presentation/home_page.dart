import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/qkomo_logo.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_content.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_header.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final gradient = ref.watch(appGradientProvider);
    final themeType = ref.watch(themeTypeProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Top Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const QkomoLogo(size: 32),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Cambiar tema',
                      onPressed: () {
                        final notifier = ref.read(themeTypeProvider.notifier);
                        notifier.state = themeType == AppThemeType.warm
                            ? AppThemeType.fresh
                            : AppThemeType.warm;
                      },
                      icon: Icon(
                        themeType == AppThemeType.warm
                            ? Icons.palette_outlined
                            : Icons.auto_awesome_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Actualizar',
                      onPressed: authController.refreshIdToken,
                      icon: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeHeader(user: user),
                      const SizedBox(height: 16),
                      HomeContent(user: user),
                      const SizedBox(height: 80), // Bottom padding for FAB/Nav
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
