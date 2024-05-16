import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.surface,
    required this.onSurface,
    required this.tertiaryFixed,
    required this.onSurfaceVariant,
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,

    /// Custom colors
    required this.tileBackgroundColor,
    required this.defaultText,
    required this.lightText,
    required this.defaultIcon,
    required this.disabledIcon,
    required this.disabledSurface,
    required this.onDisabledSurface,
    required this.linearGradient,
  });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color surface;
  final Color onSurface;
  final Color tertiaryFixed;
  final Color onSurfaceVariant;
  final Color error;
  final Color onError;
  final Color success;
  final Color onSuccess;

  /// Custom colors
  final Color tileBackgroundColor;
  final Color defaultText;
  final Color lightText;
  final Color defaultIcon;
  final Color disabledIcon;
  final Color disabledSurface;
  final Color onDisabledSurface;
  final LinearGradient linearGradient;

  @override
  ThemeExtension<AppColors> copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? surface,
    Color? onSurface,
    Color? tertiaryFixed,
    Color? onSurfaceVariant,
    Color? error,
    Color? onError,
    Color? success,
    Color? onSuccess,

    /// Custom colors
    Color? tileBackgroundColor,
    Color? defaultText,
    Color? lightText,
    Color? defaultIcon,
    Color? disabledIcon,
    Color? disabledSurface,
    Color? onDisabledSurface,
    LinearGradient? linearGradient,
  }) {
    return AppColors(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,

      /// Custom colors
      tileBackgroundColor: tileBackgroundColor ?? this.tileBackgroundColor,
      defaultText: defaultText ?? this.defaultText,
      lightText: lightText ?? this.lightText,
      defaultIcon: defaultIcon ?? this.defaultIcon,
      disabledIcon: disabledIcon ?? this.disabledIcon,
      disabledSurface: disabledSurface ?? this.disabledSurface,
      onDisabledSurface: onDisabledSurface ?? this.onDisabledSurface,
      linearGradient: linearGradient ?? this.linearGradient,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      brightness: brightness,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t) ?? onSecondary,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t) ??
              primaryContainer,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t) ??
              onPrimaryContainer,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      tertiaryFixed:
          Color.lerp(tertiaryFixed, other.tertiaryFixed, t) ?? tertiaryFixed,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t) ??
              onSurfaceVariant,
      error: Color.lerp(error, other.error, t) ?? error,
      onError: Color.lerp(onError, other.onError, t) ?? onError,
      success: Color.lerp(success, other.success, t) ?? success,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t) ?? onSuccess,

      /// Custom colors
      tileBackgroundColor:
          Color.lerp(tileBackgroundColor, other.tileBackgroundColor, t) ??
              tileBackgroundColor,
      defaultText: Color.lerp(defaultText, other.defaultText, t) ?? defaultText,
      lightText: Color.lerp(lightText, other.lightText, t) ?? lightText,
      defaultIcon: Color.lerp(defaultIcon, other.defaultIcon, t) ?? defaultIcon,
      disabledIcon:
          Color.lerp(disabledIcon, other.disabledIcon, t) ?? disabledIcon,
      disabledSurface: Color.lerp(disabledSurface, other.disabledSurface, t) ??
          disabledSurface,
      onDisabledSurface:
          Color.lerp(onDisabledSurface, other.onDisabledSurface, t) ??
              onDisabledSurface,
      linearGradient:
          LinearGradient.lerp(linearGradient, other.linearGradient, t) ??
              linearGradient,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
