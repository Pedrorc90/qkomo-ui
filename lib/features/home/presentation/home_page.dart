import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/capture/presentation/capture_bottom_sheet.dart';
import 'package:qkomo_ui/features/home/application/home_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_content.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_header.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final gradient = ref.watch(appGradientProvider);
    final themeType = ref.watch(themeTypeProvider);
    final streakDays = ref.watch(streakDaysProvider);
    final weeklyEntries = ref.watch(weeklyEntriesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: true,
            isDismissible: true,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.45,
              minChildSize: 0.3,
              maxChildSize: 0.92,
              snap: true,
              snapSizes: const [0.45, 0.92],
              builder: (context, scrollController) => CaptureBottomSheet(
                scrollController: scrollController,
              ),
            ),
          );
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
                      HomeHeader(
                        user: user,
                        streakDays: streakDays,
                        totalEntries: weeklyEntries,
                      ),
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
