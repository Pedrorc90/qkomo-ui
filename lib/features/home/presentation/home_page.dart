import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/widgets/qkomo_logo.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/home_content.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const QkomoLogo(size: 34),
            const SizedBox(width: 10),
            Text(
              'qkomo',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
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
            icon: Icon(themeType == AppThemeType.warm
                ? Icons.palette
                : Icons.auto_awesome),
          ),
          IconButton(
            tooltip: 'Actualizar token',
            onPressed: authController.refreshIdToken,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: HomeContent(user: user),
          ),
        ),
      ),
    );
  }
}
