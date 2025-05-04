import 'package:eiga/themes/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData getMobileTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: const TextTheme(),
  );
}
