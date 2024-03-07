import 'package:flutter/material.dart';

class ColorConstants {
  static Color primary = HexColor.fromHex("#410080");
  static Color purple1 = HexColor.fromHex("#410080");
  static Color purple2 = HexColor.fromHex("#6001C0");
  static Color purple3 = HexColor.fromHex("#7001E0");
  static Color purple4 = HexColor.fromHex("#8000FF");
  static Color purple5 = HexColor.fromHex("#901FFF");
  static Color red = HexColor.fromHex("#E85962");
  static Color blue = HexColor.fromHex("#2D98FE");
  static Color yellow = HexColor.fromHex("#FC9736");
  static Color green1 = HexColor.fromHex("#017A47");
  static Color green2 = HexColor.fromHex("#D1FADF");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color black = HexColor.fromHex("#000000"); // red color



  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");

  // new colors
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
 
  static Color error = HexColor.fromHex("#e61f34");
 
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