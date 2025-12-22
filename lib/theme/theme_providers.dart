import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/theme/app_theme.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

final themeTypeProvider =
    StateProvider<AppThemeType>((_) => AppThemeType.forest);

final appThemeProvider = Provider<ThemeData>((ref) {
  final type = ref.watch(themeTypeProvider);
  return AppTheme.theme(type);
});

final appGradientProvider = Provider<LinearGradient>((ref) {
  final type = ref.watch(themeTypeProvider);
  return AppTheme.gradient(type);
});
