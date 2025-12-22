import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/app/auth_gate.dart';
import 'package:qkomo_ui/core/widgets/retry_loading_overlay.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/home/presentation/home_page.dart';
import 'package:qkomo_ui/features/initialization/presentation/loading_screen.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

class QkomoApp extends ConsumerWidget {
  const QkomoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final togglesAsync = ref.watch(featureTogglesProvider);

    return MaterialApp(
      title: 'QKomo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: togglesAsync.when(
        data: (_) => const RetryLoadingOverlay(
          child: AuthGate(child: HomePage()),
        ),
        loading: () =>
            const LoadingScreen(message: 'Cargando configuración...'),
        error: (error, stack) {
          debugPrint('Error loading feature toggles: $error');
          return const RetryLoadingOverlay(
            child: AuthGate(child: HomePage()),
          );
        },
      ),
    );
  }
}
