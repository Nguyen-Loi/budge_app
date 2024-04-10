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
        primary: Color(0xFFACDD22),
        onPrimary: Color(0xFF002231),
        secondary: Color(0xFF8859FF),
        onSecondary: Color(0XFFFFFFFF),
        background: Color(0xFF002231),
        onBackground: Color(0xFFFFFFFF),
        surface: Color(0xFF002E42),
        onSurface: Color(0xFFFFFFFF),
        surfaceVariant: Color(0xFF406271),
        onSurfaceVariant: Color(0xFFBFCBD0),
        success: Color(0xFF27BA62),
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
        background: const Color(0xFFF2F2F2),
        onBackground: const Color(0xFF002E42),
        surface: const Color(0xFFF2F5F6),
        onSurface: const Color(0xFF002E42),
        surfaceVariant: const Color(0xFFF2F5F6),
        onSurfaceVariant: const Color(0xFF667C86),
        success: ColorManager.green2,
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
        chartBorderColor: darkColors.surfaceVariant,
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
        chartBorderColor: darkColors.surfaceVariant,
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
        background: darkColors.background,
        onBackground: darkColors.onBackground,
        surface: darkColors.surface,
        onSurface: darkColors.onSurface,
        surfaceVariant: darkColors.surfaceVariant,
        onSurfaceVariant: darkColors.onSurfaceVariant,
      ),

      scaffoldBackgroundColor: darkColors.background,

      /// TYPOGRAPHY
      textTheme: AppTextTheme.darkTextTheme,
      iconTheme: IconThemeData(
        color: darkColors.defaultIcon,
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkColors.background,
        foregroundColor: darkColors.onBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme.labelMedium.copyWith(color: darkColors.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )))),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: darkColors.onSurface),
          foregroundColor: darkColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkColors.background,
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
      cardTheme: CardTheme(
        color: darkColors.onSecondary,
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
        background: lightColors.background,
        onBackground: lightColors.onBackground,
        surface: lightColors.surface,
        onSurface: lightColors.onSurface,
        surfaceVariant: lightColors.surfaceVariant,
        onSurfaceVariant: lightColors.onSurfaceVariant,
      ),

      scaffoldBackgroundColor: lightColors.background,

      /// TYPOGRAPHY
      textTheme: AppTextTheme.textTheme,
      iconTheme: IconThemeData(
        color: lightColors.defaultIcon,
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: lightColors.background,
        foregroundColor: lightColors.onBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              AppTextTheme.labelMedium.copyWith(color: lightColors.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )))),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: lightColors.onSurface),
          foregroundColor: lightColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.background,
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

      cardTheme: CardTheme(
        color: lightColors.onSecondary,
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
