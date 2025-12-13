import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_content.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_header.dart';
import 'package:qkomo_ui/features/shell/state/navigation_provider.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final gradient = ref.watch(appGradientProvider);
    final themeType = ref.watch(themeTypeProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(bottomNavIndexProvider.notifier).state = 3;
        },
        child: const Icon(Icons.add_a_photo, size: 28),
      ),
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
