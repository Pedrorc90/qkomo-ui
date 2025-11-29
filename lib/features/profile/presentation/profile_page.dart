import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/token_card.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/user_summary_card.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final token = ref.watch(idTokenProvider);
    final themeType = ref.watch(themeTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Cambiar tema',
            onPressed: () {
              final notifier = ref.read(themeTypeProvider.notifier);
              notifier.state = themeType == AppThemeType.warm
                  ? AppThemeType.fresh
                  : AppThemeType.warm;
            },
            icon: Icon(themeType == AppThemeType.warm ? Icons.palette : Icons.auto_awesome),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserSummaryCard(user: user),
            const SizedBox(height: 16),
            TokenCard(token: token),
            const SizedBox(height: 16),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text('Actualizar token'),
                    subtitle: const Text('Vuelve a pedir el ID token de Firebase'),
                    onTap: authController.refreshIdToken,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar sesión'),
                    subtitle: const Text('Salir de qkomo en este dispositivo'),
                    onTap: authController.signOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
