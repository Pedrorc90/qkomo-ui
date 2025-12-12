import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';

import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/user_summary_card.dart';
import 'package:qkomo_ui/features/profile/presentation/theme_selection_page.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/profile_option_card.dart';
import 'package:qkomo_ui/features/profile/presentation/allergens_page.dart';
import 'package:qkomo_ui/features/profile/presentation/dietary_page.dart';
import 'package:qkomo_ui/features/settings/application/settings_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      appBar: const QkomoNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserSummaryCard(user: user),
            const SizedBox(height: 24),
            Text(
              'Datos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            ProfileOptionCard(
              title: 'Historial',
              icon: Icons.history,
              subtitle: 'Ver tu historial de comidas',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Preferencias',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            ProfileOptionCard(
              title: 'Mis Alérgenos',
              icon: Icons.warning_amber_rounded,
              subtitle: 'Gestiona tus alertas de alérgenos',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllergensPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ProfileOptionCard(
              title: 'Restricciones',
              icon: Icons.restaurant_menu,
              subtitle: 'Dietas y restricciones alimentarias',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DietaryPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const _NotificationOption(),
            const SizedBox(height: 8),
            const _LanguageOption(),
            const SizedBox(height: 24),
            Text(
              'Apariencia',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            ProfileOptionCard(
              title: 'Apariencia',
              icon: Icons.palette_outlined,
              subtitle: 'Personaliza los colores de la app',
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => const ThemeSelectionPage()));
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Cuenta',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                subtitle: const Text('Salir de qkomo en este dispositivo'),
                onTap: authController.signOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationOption extends ConsumerWidget {
  const _NotificationOption();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider).asData?.value;
    final enabled = settings?.enableNotifications ?? false;

    return Card(
      child: SwitchListTile(
        title: const Text('Notificaciones'),
        subtitle: const Text('Activar recordatorios diarios'),
        secondary: Icon(
          enabled ? Icons.notifications_active : Icons.notifications_off,
          color: Theme.of(context).colorScheme.primary,
        ),
        value: enabled,
        onChanged: (value) {
          ref.read(userSettingsProvider.notifier).setNotificationsEnabled(value);
        },
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption();

  @override
  Widget build(BuildContext context) {
    return ProfileOptionCard(
      title: 'Idioma',
      icon: Icons.language,
      subtitle: 'Español (España)',
      onTap: () {},
    );
  }
}
