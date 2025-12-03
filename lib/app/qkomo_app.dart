import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/home/presentation/home_page.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';
import 'package:qkomo_ui/app/auth_gate.dart';

class QkomoApp extends ConsumerWidget {
  const QkomoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'qkomo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const AuthGate(child: HomePage()),
    );
  }
}
