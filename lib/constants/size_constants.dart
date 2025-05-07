import 'package:flutter/material.dart';

class SizeConstants {
  static const double maxWidthBase = 700;
  static const double tablet = 700;
  static const double desktop = 1200;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < tablet;
  }
}
