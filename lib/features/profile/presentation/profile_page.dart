import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/user_summary_card.dart';
import 'package:qkomo_ui/features/profile/application/companion_controller.dart';
import 'package:qkomo_ui/features/profile/presentation/allergens_page.dart';
import 'package:qkomo_ui/features/profile/presentation/dietary_page.dart';
import 'package:qkomo_ui/features/profile/presentation/theme_selection_page.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/add_companion_dialog.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/profile_option_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const QkomoNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserSummaryCard(user: user),
            const SizedBox(height: 24),
            const _CompanionSection(),
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
              title: 'Preferencias Dietéticas',
              icon: Icons.restaurant_menu,
              subtitle: 'Preferencias para tus comidas',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DietaryPage(),
                  ),
                );
              },
            ),
            //const SizedBox(height: 8),
            //const _NotificationOption(),
            //const SizedBox(height: 8),
            //const _LanguageOption(),
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
                ).push(MaterialPageRoute(
                    builder: (context) => const ThemeSelectionPage()));
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

class _CompanionSection extends ConsumerWidget {
  const _CompanionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check feature toggle for companion section
    // If not found, defaults to false in safe mode, but we want it enabled by default?
    // User requested "oculta ... dependendiendo del feature features.api.companion"
    // Usually features are opt-in or opt-out.
    // Assuming if key is missing -> disabled (safe default in provider).
    // If key exists and is false -> disabled.
    // If key exists and is true -> enabled.
    final isEnabled =
        ref.watch(featureEnabledProvider('features.api.companion'));

    if (!isEnabled) {
      return const SizedBox.shrink();
    }

    final companionListAsync = ref.watch(companionListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Comunidad',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        companionListAsync.when(
          data: (companions) {
            if (companions.isEmpty) {
              return ProfileOptionCard(
                title: 'Añadir Compañero',
                icon: Icons.person_add_alt_1_outlined,
                subtitle: 'Comparte tu menú semanal',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddCompanionDialog(),
                  );
                },
              );
            }

            final companion = companions.first;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: companion.photoUrl != null
                      ? NetworkImage(companion.photoUrl!)
                      : null,
                  child: companion.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(companion.displayName ?? companion.email),
                subtitle: Text(
                  companion.isPending ? 'Invitación enviada' : 'Compañero',
                  style: TextStyle(
                    color: companion.isPending
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => Dialog(
                        insetPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Desvincular compañero',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  '¿Seguro que quieres eliminar a ${companion.displayName ?? companion.email}? Dejarán de compartir el menú semanal.'),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Desvincular'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (confirm == true) {
                      await ref
                          .read(companionControllerProvider.notifier)
                          .removeCompanion(companion.id);
                      ref.invalidate(companionListProvider);
                    }
                  },
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => ProfileOptionCard(
            title: 'Error de conexión',
            icon: Icons.error_outline,
            subtitle: 'No se pudo cargar la información',
            onTap: () => ref.invalidate(companionListProvider),
          ),
        ),
      ],
    );
  }
}
