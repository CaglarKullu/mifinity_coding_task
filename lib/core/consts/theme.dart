import 'package:flutter/material.dart';

import 'app_colors.dart';

final ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary colors
  primary: AppColors.primaryColor,
  onPrimary: Colors.white,
  primaryContainer: Colors.red.shade700,
  onPrimaryContainer: Colors.white,
  primaryFixed: AppColors.primaryColor,
  primaryFixedDim: Colors.red.shade800,
  onPrimaryFixed: Colors.white,
  onPrimaryFixedVariant: Colors.red.shade300,

  // Secondary colors
  secondary: Colors.grey.shade800,
  onSecondary: Colors.white,
  secondaryContainer: Colors.grey.shade700,
  onSecondaryContainer: Colors.white,
  secondaryFixed: Colors.grey.shade800,
  secondaryFixedDim: Colors.grey.shade900,
  onSecondaryFixed: Colors.white,
  onSecondaryFixedVariant: Colors.grey.shade400,

  // Tertiary colors
  tertiary: Colors.teal.shade400,
  onTertiary: Colors.white,
  tertiaryContainer: Colors.teal.shade600,
  onTertiaryContainer: Colors.white,
  tertiaryFixed: Colors.teal.shade400,
  tertiaryFixedDim: Colors.teal.shade700,
  onTertiaryFixed: Colors.white,
  onTertiaryFixedVariant: Colors.teal.shade300,

  // Error colors
  error: Colors.red.shade900,
  onError: Colors.white,
  errorContainer: Colors.red.shade600,
  onErrorContainer: Colors.white,

  // Outline colors
  outline: Colors.grey,
  outlineVariant: Colors.grey.shade700,

  // Surface colors
  surface: AppColors.backgroundColor,
  onSurface: AppColors.textColor,
  surfaceDim: Colors.black,
  surfaceBright: Colors.grey.shade900,
  surfaceContainerLowest: Colors.grey.shade800,
  surfaceContainerLow: Colors.grey.shade700,
  surfaceContainer: Colors.grey.shade600,
  surfaceContainerHigh: Colors.grey.shade500,
  surfaceContainerHighest: Colors.grey.shade400,
  onSurfaceVariant: Colors.grey.shade500,
  inverseSurface: Colors.white,
  onInverseSurface: Colors.black,

  // Inverse Primary color
  inversePrimary: Colors.red.shade300,

  // Miscellaneous colors
  shadow: Colors.black,
  scrim: Colors.black.withOpacity(0.5),
  surfaceTint: AppColors.primaryColor,
);

class FakeflixTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heading,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.secondaryBody,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: AppTextStyles.heading,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary,
        labelTextStyle: WidgetStateProperty.all(AppTextStyles.body),
      ),
    );
  }
}
