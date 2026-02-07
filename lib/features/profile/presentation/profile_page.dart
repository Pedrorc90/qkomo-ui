import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/user_summary_card.dart';
import 'package:qkomo_ui/features/profile/application/companion_controller.dart';
import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';
import 'package:qkomo_ui/features/profile/presentation/allergens_page.dart';
import 'package:qkomo_ui/features/profile/presentation/dietary_page.dart';
import 'package:qkomo_ui/features/profile/presentation/theme_selection_page.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/add_companion_dialog.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/companion_card.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/profile_option_card.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/profile_section_header.dart';
import 'package:qkomo_ui/features/profile/presentation/widgets/remove_companion_dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final showAppearance = ref.watch(
      featureEnabledProvider(FeatureToggleKeys.showAppearance),
    );

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
            const ProfileSectionHeader(title: 'Preferencias'),
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
            if (showAppearance) ...[
              const SizedBox(height: 24),
              const ProfileSectionHeader(title: 'Apariencia'),
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
            ],
            const SizedBox(height: 24),
            const ProfileSectionHeader(title: 'Cuenta'),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Salir de qkomo en este dispositivo',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
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

  Future<void> _handleRemoveCompanion(
    BuildContext context,
    WidgetRef ref,
    Companion companion,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveCompanionDialog(
        companionName: companion.displayName ?? companion.email,
      ),
    );

    if (confirm == true) {
      await ref
          .read(companionControllerProvider.notifier)
          .removeCompanion(companion.id);
      ref.invalidate(companionListProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled =
        ref.watch(featureEnabledProvider(FeatureToggleKeys.companion));

    if (!isEnabled) {
      return const SizedBox.shrink();
    }

    final companionListAsync = ref.watch(companionListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ProfileSectionHeader(title: 'Comunidad'),
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
            return CompanionCard(
              companion: companion,
              onRemove: () => _handleRemoveCompanion(context, ref, companion),
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
