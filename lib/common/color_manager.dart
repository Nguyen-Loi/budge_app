import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#7001E0");

  static Color purple11 = HexColor.fromHex("#410080");
  static Color purple12 = HexColor.fromHex("#6001C0");
  static Color purple13 = HexColor.fromHex("#7001E0");
  static Color purple14 = HexColor.fromHex("#8000FF");
  static Color purple15 = HexColor.fromHex("#901FFF");

  static Color purple21 = HexColor.fromHex("#A040FF");
  static Color purple22 = HexColor.fromHex("#AF60FF");
  static Color purple23 = HexColor.fromHex("#C080FF");
  static Color purple24 = HexColor.fromHex("#D2AFF5");
  static Color purple25 = HexColor.fromHex("#D2AFF5");

  static Color red = HexColor.fromHex("#E85962");
  static Color blue = HexColor.fromHex("#2D98FE");
  static Color yellow = HexColor.fromHex("#FC9736");
  static Color green1 = HexColor.fromHex("#017A47");
  static Color green2 = HexColor.fromHex("#D1FADF");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color black = HexColor.fromHex("#000000");
  static Color orange = HexColor.fromHex("#FE7C2F");

  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("F5E8DD");

  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");

  // new colors
  static Color darkPrimary = HexColor.fromHex("#d17d11");

  static Color error = HexColor.fromHex("#e61f34");

  static LinearGradient linearGreen = LinearGradient(colors: [
    HexColor.fromHex('#11998e'),
    HexColor.fromHex('#38ef7d'),
  ]);
  static LinearGradient linearWarning = LinearGradient(colors: [
    HexColor.fromHex('#f12711'),
    HexColor.fromHex('#f5af19'),
  ]);
  static LinearGradient linearDanger = LinearGradient(colors: [
    HexColor.fromHex('#e52d27'),
    HexColor.fromHex('#b31217'),
  ]);
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
