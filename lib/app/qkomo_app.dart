import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/presentation/home_page.dart';
import '../theme/theme_providers.dart';
import 'auth_gate.dart';

class qkomoApp extends ConsumerWidget {
  const qkomoApp({super.key});

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
