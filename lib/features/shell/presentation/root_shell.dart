import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/home/presentation/home_page.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';
import 'package:qkomo_ui/features/profile/presentation/profile_page.dart';

import 'package:qkomo_ui/features/shell/state/navigation_provider.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: index,
          children: const [
            WeeklyMenuPage(),
            HomePage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: NavigationBar(
                selectedIndex: index,
                height: 65,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                indicatorColor: Colors.transparent,
                onDestinationSelected: (value) =>
                    ref.read(bottomNavIndexProvider.notifier).state = value,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.calendar_month_outlined, size: 24),
                    selectedIcon: Icon(Icons.calendar_month, size: 32),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined, size: 24),
                    selectedIcon: Icon(Icons.home_rounded, size: 32),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_2_outlined, size: 24),
                    selectedIcon: Icon(Icons.person, size: 32),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
