import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/constants/font_family_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
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
        primary: Color(0xFF1976D2),
        onPrimary: Colors.white,
        secondary: Color(0xFF42A5F5),
        onSecondary: Color(0xFF000000),
        primaryContainer: Color(0xFF0D253F),
        onPrimaryContainer: Color(0xFFFFFFFF),
        surface: Color(0xFF121212),
        onSurface: Color(0xFFFFFFFF),
        tertiaryFixed: Color(0xFF42A5F5),
        onSurfaceVariant: Color(0xFFBFCBD0),
        success: Color(0XFF6ABC2C),
        onSuccess: Color(0xFFFFFFFF),
        error: Colors.red,
        onError: Color(0xFFFFFFFF),

        /// Custom colors
        tileBackgroundColor: Color(0xFF102840),
        defaultText: Color(0XFFFFFFFF),
        lightText: Color(0XFFBFCBD0),
        defaultIcon: Color(0XFF90CAF9),
        disabledIcon: Color(0XFF8097A0),
        disabledSurface: Color(0XFF1A2A3A),
        onDisabledSurface: Color(0XFFBFCBD0),
        linearGradient: LinearGradient(
          colors: [
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
            Color(0xFF0D253F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static AppColors get lightColors => AppColors(
        brightness: Brightness.dark,
        primary: ColorManager.primaryBlue,
        onPrimary: ColorManager.white,
        secondary: ColorManager.secondaryBlue,
        onSecondary: ColorManager.white,

        primaryContainer: ColorManager.white,
        onPrimaryContainer: ColorManager.darkBlueText,

        surface: ColorManager.white,
        onSurface: ColorManager.darkBlueText,

        tertiaryFixed: ColorManager.secondaryBlue,
        onSurfaceVariant: ColorManager.greyText,

        success: ColorManager.successGreen,
        onSuccess: ColorManager.white,
        error: ColorManager.errorRed,
        onError: ColorManager.white,

        /// Custom colors
        tileBackgroundColor: ColorManager.lightBlueBackground,
        defaultText: ColorManager.darkBlueText,
        lightText: ColorManager.greyText,

        defaultIcon: ColorManager.secondaryBlue,
        disabledIcon: ColorManager.disabledGrey,
        disabledSurface: ColorManager.disabledSurfaceGrey,
        onDisabledSurface: ColorManager.onDisabledSurfaceText,

        linearGradient: LinearGradient(
          colors: [
            ColorManager.gradientBlueStart,
            ColorManager.gradientBlueAlt1,
            ColorManager.gradientBlueMid,
            ColorManager.gradientBlueAlt2,
            ColorManager.gradientBlueEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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

  static ButtonStyle get _buttonStyleBase {
    return ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 24,
      )),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      )),
    );
  }

  /// theme
  static ThemeData get darkTheme {
    return ThemeData(
      /// COLOR
      fontFamily: fontFamilyInter,
      brightness: Brightness.dark,
      disabledColor: darkColors.disabledSurface,
      snackBarTheme: SnackBarThemeData(
          actionTextColor: darkColors.onPrimary,
          backgroundColor: darkColors.secondary,
          elevation: 20),
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
          surface: ColorManager.cardColorDark,
          onSurface: darkColors.onSurface,
          tertiaryFixed: Color(0XFF80DCC5),
          onSurfaceVariant: darkColors.onSurfaceVariant,
          //custom
          secondaryContainer: const Color.fromARGB(255, 7, 130, 118),
          tertiary: Color(0XFF00A884)),

      scaffoldBackgroundColor: darkColors.primaryContainer,

      /// TYPOGRAPHY
      textTheme: AppTextTheme.darkTextTheme,
      iconTheme: IconThemeData(
        color: darkColors.defaultIcon,
      ),
      dividerColor: ColorManager.greyDark,

      /// COMPONENT THEMES
      actionIconTheme: ActionIconThemeData(backButtonIconBuilder: (_) {
        return Icon(
          IconManager.back,
          color: darkColors.onPrimary,
        );
      }),
      appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: darkColors.primary,
          foregroundColor: darkColors.onPrimary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme.labelLarge.copyWith(color: darkColors.error),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: darkColors.primaryContainer),
      filledButtonTheme: FilledButtonThemeData(style: _buttonStyleBase),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: darkColors.secondary),

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
        focusedBorder: darkColors.primary.getOutlineBorder,
        iconColor: ColorManager.greyDark,
        enabledBorder: ColorManager.primaryBlue.getOutlineBorder,
        disabledBorder: ColorManager.greyLight.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelStyle: AppTextTheme.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        labelColor: darkColors.primary,
        unselectedLabelColor: darkColors.onPrimary.withAlpha(150),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: darkColors.primary,
        dividerHeight: 3,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20),
        unselectedLabelStyle:AppTextTheme.bodyMedium,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: darkColors.primary,
              width: 3,
            ),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorManager.cardColorDark,
        margin: EdgeInsets.zero,
        elevation: 2,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        borderRadius: BorderRadius.circular(8),
        circularTrackColor: darkColors.secondary,
        linearTrackColor: darkColors.onSecondary,
        color: darkColors.primary.withAlpha(200),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: darkColors.secondary.withAlpha(50),
        selectedColor: darkColors.secondary,
        disabledColor: darkColors.disabledSurface,
        labelStyle: AppTextTheme.bodyMedium.copyWith(
          color: darkColors.onPrimary,
        ),
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
      fontFamily: fontFamilyInter,
      disabledColor: lightColors.disabledSurface,
      snackBarTheme: SnackBarThemeData(
          actionTextColor: lightColors.onPrimary,
          backgroundColor: lightColors.secondary,
          elevation: 20),
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
        surface: lightColors.primaryContainer,
        onSurface: lightColors.onSurface,
        tertiaryFixed: Color(0XFF80DCC5),
        onSurfaceVariant: lightColors.onSurfaceVariant,
        secondaryContainer: ColorManager.primaryBlue,
        tertiary: Color(0XFF00B894),
      ),

      scaffoldBackgroundColor: lightColors.primaryContainer,

      /// TYPOGRAPHY
      textTheme: AppTextTheme.textTheme,
      iconTheme: IconThemeData(
        color: lightColors.defaultIcon,
      ),

      dividerColor: ColorManager.greyLight,

      /// COMPONENT THEMES
      actionIconTheme: ActionIconThemeData(backButtonIconBuilder: (_) {
        return Icon(
          IconManager.back,
          color: lightColors.onPrimary,
        );
      }),
      appBarTheme: AppBarTheme(
        elevation: 1,
        centerTitle: true,
        backgroundColor: lightColors.primary,
        foregroundColor: lightColors.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme.labelLarge.copyWith(color: lightColors.error),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: lightColors.primaryContainer),
      filledButtonTheme: FilledButtonThemeData(style: _buttonStyleBase),

      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: lightColors.secondary),
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
          focusedBorder: lightColors.primary.getOutlineBorder,
          iconColor: ColorManager.greyLight,
          enabledBorder: ColorManager.greyLight.getEnabledBorder,
          disabledBorder: ColorManager.greyLight.getOutlineBorder,
          errorMaxLines: 3,
          contentPadding: EdgeInsets.all(8)),
      tabBarTheme: TabBarThemeData(
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

      cardTheme: CardThemeData(
        color: ColorManager.cardColorLight,
        margin: EdgeInsets.zero,
        elevation: 2,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        borderRadius: BorderRadius.circular(8),
        circularTrackColor: lightColors.secondary,
        linearTrackColor: lightColors.onSecondary,
        color: lightColors.primary.withAlpha(200),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: lightColors.secondary.withAlpha(50),
        selectedColor: lightColors.secondary,
        disabledColor: lightColors.disabledSurface,
        labelStyle: AppTextTheme.bodyMedium.copyWith(
          color: lightColors.onPrimary,
        ),
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
