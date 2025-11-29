import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/capture/presentation/capture_page.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';
import 'package:qkomo_ui/features/home/presentation/home_page.dart';
import 'package:qkomo_ui/features/profile/presentation/profile_page.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

import '../state/navigation_provider.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);
    final gradient = ref.watch(appGradientProvider);
    final themeType = ref.watch(themeTypeProvider);

    return Scaffold(
      extendBody: true,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          top: false,
          child: IndexedStack(
            index: index,
            children: const [HomePage(), CapturePage(), HistoryPage(), ProfilePage()],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 74,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) => ref.read(bottomNavIndexProvider.notifier).state = value,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          const NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Captura',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_toggle_off),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(themeType == AppThemeType.warm ? Icons.person_outline : Icons.person),
            selectedIcon: const Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
