import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/theme/app_colors.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:budget_app/theme/asset_tile_style.dart';
import 'package:budget_app/theme/chart_style.dart';
import 'package:budget_app/theme/helper.dart';
import 'package:budget_app/theme/transaction_tile_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  /// colors and styles
  static AppColors get darkColors => const AppColors(
        brightness: Brightness.dark,
        primary: Color(0XFFBB86FC),
        onPrimary: Color(0xFF000000),
        secondary: Color(0XFF03DAC5),
        onSecondary: Color(0xFF000000),
        primaryContainer: Color(0xFF121212),
        onPrimaryContainer: Color(0xFFFFFFFF),
        surface: Color(0xFF121212),
        onSurface: Color(0xFFFFFFFF),
        tertiaryFixed: Color(0xFF406271),
        onSurfaceVariant: Color(0xFFBFCBD0),
        success: Color(0XFF6ABC2C),
        onSuccess: Color(0xFFFFFFFF),
        error: Colors.red,
        onError: Color(0xFFFFFFFF),

        /// Custom colors
        tileBackgroundColor: Color(0XFF002E42),
        defaultText: Color(0XFFFFFFFF),
        lightText: Color(0XFFBFCBD0),
        defaultIcon: Color(0XFFBFCBD0),
        disabledIcon: Color(0XFF8097A0),
        disabledSurface: Color(0XFF8097A0),
        onDisabledSurface: Color(0XFFBFCBD0),
        linearGradient: LinearGradient(
          colors: [
            Color(0xFF27BA62),
            Color(0xFF137A61),
            Color(0xFF0B6060),
          ],
        ),
      );

  static AppColors get lightColors => AppColors(
        brightness: Brightness.dark,
        primary: ColorManager.purple13,
        onPrimary: ColorManager.black,
        secondary: ColorManager.purple23,
        onSecondary: ColorManager.white,
        primaryContainer: const Color(0xFFF2F2F2),
        onPrimaryContainer: const Color(0xFF002E42),
        surface: const Color(0xFFF2F5F6),
        onSurface: const Color(0xFF002E42),
        tertiaryFixed: const Color(0xFFF2F5F6),
        onSurfaceVariant: const Color(0xFF667C86),
        success: const Color(0XFF017A47),
        onSuccess: ColorManager.white,
        error: Colors.red,
        onError: ColorManager.white,

        /// Custom colors
        tileBackgroundColor: const Color(0xFFF2F5F6),
        defaultText: const Color(0XFF002E42),
        lightText: const Color(0XFF667C86),
        defaultIcon: ColorManager.purple22, //Hover icon button
        disabledIcon: const Color(0XFF8097A0),
        disabledSurface: const Color(0XFFD2DBDE),
        onDisabledSurface: const Color(0XFFA0B1B8),
        linearGradient: LinearGradient(
          colors: [
            ColorManager.purple21,
            ColorManager.purple22,
            ColorManager.purple23,
            ColorManager.purple24,
            ColorManager.purple25,
          ],
        ),
      );

  static TransactionTileStyle get transactionTileStyleDark =>
      TransactionTileStyle(
        backgroundColor: darkColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static TransactionTileStyle get transactionTileStyleLight =>
      TransactionTileStyle(
        backgroundColor: lightColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static AssetTileStyle get assetTileStyleDark => AssetTileStyle(
        backgroundColor: darkColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static AssetTileStyle get assetTileStyleLight => AssetTileStyle(
        backgroundColor: lightColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static FLChartStyle get chartStyleDark => FLChartStyle(
        backgroundColor: darkColors.surface,
        chartColor1: darkColors.linearGradient.colors[0],
        chartColor2: darkColors.linearGradient.colors[1],
        chartColor3: darkColors.linearGradient.colors[2],
        chartBorderColor: darkColors.tertiaryFixed,
        toolTipBgColor: darkColors.onSurfaceVariant,
        isShowingMainData: true,
        animationDuration: const Duration(milliseconds: 100),
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
        borderRadius: 12,
      );

  static FLChartStyle get chartStyleLight => FLChartStyle(
        backgroundColor: darkColors.surface,
        chartColor1: darkColors.linearGradient.colors[0],
        chartColor2: darkColors.linearGradient.colors[1],
        chartColor3: darkColors.linearGradient.colors[2],
        chartBorderColor: darkColors.tertiaryFixed,
        toolTipBgColor: darkColors.onSurfaceVariant,
        isShowingMainData: false,
        animationDuration: const Duration(milliseconds: 100),
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
        borderRadius: 12,
      );

  /// theme
  static ThemeData get darkTheme {
    return ThemeData(
      /// COLOR
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: darkColors.brightness,
          primary: darkColors.primary,
          onPrimary: darkColors.onPrimary,
          secondary: darkColors.secondary,
          onSecondary: darkColors.onSecondary,
          error: darkColors.error,
          onError: darkColors.onError,
          primaryContainer: darkColors.primaryContainer,
          onPrimaryContainer: darkColors.onPrimaryContainer,
          surface: darkColors.surface,
          onSurface: darkColors.onSurface,
          tertiaryFixed: darkColors.tertiaryFixed,
          onSurfaceVariant: darkColors.onSurfaceVariant,

          // Success
          tertiary: darkColors.success),

      scaffoldBackgroundColor: darkColors.primaryContainer,

      /// TYPOGRAPHY
      textTheme: AppTextTheme.darkTextTheme,
      iconTheme: IconThemeData(
        color: darkColors.defaultIcon,
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 1,
        centerTitle: true,
        backgroundColor: darkColors.surface,
        foregroundColor: darkColors.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme.labelLarge.copyWith(color: darkColors.error),
        ),
      ),
      dialogBackgroundColor: darkColors.primaryContainer,
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              padding:
                  WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )))),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: ColorManager.purple13),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: darkColors.onSurface),
          foregroundColor: darkColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkColors.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColors.onSecondary,
        errorStyle: AppTextTheme.bodySmall.copyWith(color: darkColors.error),
        helperStyle:
            AppTextTheme.bodySmall.copyWith(color: darkColors.onSurfaceVariant),
        hintStyle: AppTextTheme.bodyMedium
            .copyWith(color: darkColors.onSurfaceVariant),
        focusedErrorBorder: darkColors.error.getOutlineBorder,
        errorBorder: darkColors.error.getOutlineBorder,
        focusedBorder: ColorManager.primary.getOutlineBorder,
        iconColor: darkColors.onSurfaceVariant,
        enabledBorder: ColorManager.primary.getOutlineBorder,
        disabledBorder: ColorManager.grey1.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        labelStyle: AppTextTheme.bodyLarge,
        labelColor: darkColors.primary,
        unselectedLabelColor: darkColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: darkColors.primary,
              width: 3,
            ),
          ),
        ),
      ),
      cardTheme: const CardTheme(
        color: Color(0XFF1E1E1E),
        margin: EdgeInsets.zero,
        elevation: 2,
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        darkColors,
        assetTileStyleDark,
        transactionTileStyleDark,
        chartStyleDark,
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      /// COLOR
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: lightColors.brightness,
        primary: lightColors.primary,
        onPrimary: lightColors.onPrimary,
        secondary: lightColors.secondary,
        onSecondary: lightColors.onSecondary,
        error: lightColors.error,
        onError: lightColors.onError,

        primaryContainer: lightColors.primaryContainer,
        onPrimaryContainer: lightColors.onPrimaryContainer,
        surface: lightColors.surface,
        onSurface: lightColors.onSurface,
        tertiaryFixed: lightColors.tertiaryFixed,
        onSurfaceVariant: lightColors.onSurfaceVariant,

        // Success
        tertiary: lightColors.success,
      ),

      scaffoldBackgroundColor: lightColors.primaryContainer,

      /// TYPOGRAPHY
      textTheme: AppTextTheme.textTheme,
      iconTheme: IconThemeData(
        color: lightColors.defaultIcon,
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 1,
        centerTitle: true,
        backgroundColor: lightColors.primaryContainer,
        foregroundColor: lightColors.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme.labelLarge.copyWith(color: lightColors.error),
        ),
      ),
      dialogBackgroundColor: lightColors.primaryContainer,
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              padding:
                  WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )))),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: ColorManager.purple13),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: lightColors.onSurface),
          foregroundColor: lightColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColors.onSecondary,
        errorStyle: AppTextTheme.bodySmall.copyWith(color: lightColors.error),
        helperStyle: AppTextTheme.bodySmall
            .copyWith(color: lightColors.onSurfaceVariant),
        hintStyle: AppTextTheme.bodyMedium
            .copyWith(color: lightColors.onSurfaceVariant),
        focusedErrorBorder: lightColors.error.getOutlineBorder,
        errorBorder: lightColors.error.getOutlineBorder,
        focusedBorder: ColorManager.primary.getOutlineBorder,
        iconColor: darkColors.onSurfaceVariant,
        enabledBorder: ColorManager.grey1.getOutlineBorder,
        disabledBorder: ColorManager.grey1.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        labelStyle: AppTextTheme.bodyLarge,
        labelColor: lightColors.primary,
        unselectedLabelColor: lightColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: lightColors.primary,
              width: 3,
            ),
          ),
        ),
      ),

      cardTheme: const CardTheme(
        color: Color(0XFFFFFFFF),
        margin: EdgeInsets.zero,
        elevation: 2,
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        lightColors,
        assetTileStyleLight,
        transactionTileStyleLight,
        chartStyleLight,
      ],
    );
  }
}
