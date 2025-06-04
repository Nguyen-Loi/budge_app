import 'package:flutter/material.dart';

class ColorManager {

  static Color red1 = HexColor.fromHex("#E85962");
  static Color red2 = HexColor.fromHex("#DE4C5F");

  static Color blue = HexColor.fromHex("#2D98FE");
  static Color yellow = HexColor.fromHex("#FC9736");
  static Color red = Colors.red;
  static Color green = Colors.green;

  static Color white = HexColor.fromHex("#FFFFFF");
  static Color black = HexColor.fromHex("#000000");
  static Color orange = HexColor.fromHex("#FE7C2F");

  static Color greyLight = HexColor.fromHex("#6B7280");
  static Color greyDark = HexColor.fromHex("#9CA3AF");
  static Color grey2 = Colors.grey.shade300;
  static Color grey = Colors.grey;

  static Color cardColorLight = HexColor.fromHex("#F9FAFB");
  static Color cardColorDark = HexColor.fromHex("#1F2937");

  static Color error = HexColor.fromHex("#e61f34");

  static LinearGradient linearGreen1 = LinearGradient(colors: [
    HexColor.fromHex('#11998e'),
    HexColor.fromHex('#38ef7d'),
  ]);
  static LinearGradient linearGrey = LinearGradient(colors: [
    HexColor.fromHex('#bdc3c7'),
    HexColor.fromHex('#2c3e50'),
  ]);
  static LinearGradient linearPink = LinearGradient(colors: [
    HexColor.fromHex('#ee9ca7'),
    HexColor.fromHex('#ffdde1'),
  ]);
  static LinearGradient linearGreen2 = LinearGradient(colors: [
    HexColor.fromHex('#DCE35B'),
    HexColor.fromHex('#45B649'),
  ]);
  static LinearGradient linearWarning = LinearGradient(colors: [
    HexColor.fromHex('#f12711'),
    HexColor.fromHex('#f5af19'),
  ]);
  static LinearGradient linearDanger = LinearGradient(colors: [
    HexColor.fromHex('#e52d27'),
    HexColor.fromHex('#b31217'),
  ]);
  static LinearGradient linearBlue = LinearGradient(colors: [
    HexColor.fromHex('#2E3192'),
    HexColor.fromHex('#1BFFFF'),
  ]);
  static LinearGradient linearPrimary = LinearGradient(colors: [
    HexColor.fromHex('#614385'),
    HexColor.fromHex('#516395'),
  ]);


  static const Color primaryBlue = Color(0xFF0D47A1); 
  static const Color secondaryBlue = Color(0xFF1976D2);
  static const Color lightBlueBackground = Color(0xFFE3F2FD);
  static const Color darkBlueText = Color(0xFF001E3C); 

  // --- GRADIENT ---
  static const Color gradientBlueStart = Color(0xFF0D47A1);
  static const Color gradientBlueMid = Color(0xFF1976D2);
  static const Color gradientBlueEnd = Color(0xFF2196F3); 
  static const Color gradientBlueAlt1 = Color(0xFF1565C0);
  static const Color gradientBlueAlt2 = Color(0xFF1E88E5);


  static const Color greyText = Color(0xFF5A788A); 
  static const Color successGreen = Color(0XFF22C55E);
  static const Color errorRed = Color(0xFFD32F2F); 

  static const Color disabledGrey = Color(0XFFB0BEC5); 
  static const Color disabledSurfaceGrey = Color(0XFFECEFF1); 
  static const Color onDisabledSurfaceText = Color(0XFF78909C); 
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
