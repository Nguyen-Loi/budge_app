import 'package:budget_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  const AppTextTheme._();

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge:
        headlineLarge.copyWith(color: AppTheme.darkColors.defaultText),
    headlineMedium:
        headlineMedium.copyWith(color: AppTheme.darkColors.defaultText),
    headlineSmall:
        headlineSmall.copyWith(color: AppTheme.darkColors.defaultText),
    bodyLarge: bodyLarge.copyWith(color: AppTheme.darkColors.defaultText),
    bodyMedium: bodyMedium.copyWith(color: AppTheme.darkColors.defaultText),
    bodySmall: bodySmall.copyWith(color: AppTheme.darkColors.defaultText),
    labelLarge: labelLarge.copyWith(color: AppTheme.darkColors.defaultText),
  );

  static TextTheme textTheme = TextTheme(
    headlineLarge:
        headlineLarge.copyWith(color: AppTheme.lightColors.defaultText),
    headlineMedium:
        headlineMedium.copyWith(color: AppTheme.lightColors.defaultText),
    headlineSmall:
        headlineSmall.copyWith(color: AppTheme.lightColors.defaultText),
    bodyLarge: bodyLarge.copyWith(color: AppTheme.lightColors.defaultText),
    bodyMedium: bodyMedium.copyWith(color: AppTheme.lightColors.defaultText),
    bodySmall: bodySmall.copyWith(color: AppTheme.lightColors.defaultText),
    labelLarge: labelLarge.copyWith(color: AppTheme.lightColors.defaultText),
  );

  static const TextStyle headlineLarge = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 26,
      letterSpacing: 1.5,
      wordSpacing: 0.5);

  static const TextStyle headlineMedium = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.w400, // Regular
    fontSize: 14,
  );

  static const TextStyle labelLarge = TextStyle(
    fontWeight: FontWeight.w500, // Medium
    fontSize: 12,
  );
}

extension AppTextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
