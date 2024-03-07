import 'package:budget_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColorConstants.white,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorConstants.purple2,
    ),
  );
}
