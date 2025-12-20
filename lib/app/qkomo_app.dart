import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/home/presentation/home_page.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';
import 'package:qkomo_ui/app/auth_gate.dart';
import 'package:qkomo_ui/core/widgets/retry_loading_overlay.dart';

class QkomoApp extends ConsumerWidget {
  const QkomoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'QKomo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      builder: (context, child) {
        return RetryLoadingOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AuthGate(child: HomePage()),
    );
  }
}
