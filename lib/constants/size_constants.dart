import 'package:flutter/material.dart';

class SizeConstants {
  SizeConstants._();

  static const double maxWidthBase = 700;
  static const double buttonMaxWidth = 200;
  static const double tablet = 700;
  static const double desktop = 1200;
  static const double gridSize = 1000;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < tablet;
  }
}
