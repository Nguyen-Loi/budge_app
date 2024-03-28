import 'package:budget_app/common/color_manager.dart';
import 'package:flutter/material.dart';

enum _BTextType {
  heading1,
  heading2,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
}

const String _fontName = 'PublicSans';

class BText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;
  // ignore: library_private_types_in_public_api
  final _BTextType textType;

  const BText.h1(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    super.key,
  }) : textType = _BTextType.heading1;

  const BText.h2(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    super.key,
  }) : textType = _BTextType.heading2;

  const BText.b1(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    super.key,
  }) : textType = _BTextType.bodyLarge;

  const BText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    super.key,
  }) : textType = _BTextType.bodyMedium;

  const BText.b3(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    super.key,
  }) : textType = _BTextType.bodySmall;

  const BText.caption(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    super.key,
  }) : textType = _BTextType.caption;

  Widget _heading1() {
    return Text(
      text,
      textAlign: textAlign,
      style: BTextStyle.heading1(color: color, fontWeight: fontWeight),
    );
  }

  Widget _heading2() {
    return Text(
      text,
      textAlign: textAlign,
      style: BTextStyle.heading2(color: color, fontWeight: fontWeight),
    );
  }

  Widget _bodyLarge() {
    return Text(
      text,
      textAlign: textAlign,
      style: BTextStyle.bodyLarge(color: color, fontWeight: fontWeight),
    );
  }

  Widget _bodyMedium() {
    return Text(
      text,
      textAlign: textAlign,
      style: BTextStyle.bodyMedium(color: color, fontWeight: fontWeight),
    );
  }

  Widget _bodySmall() {
    return Text(
      text,
      textAlign: textAlign,
      style: BTextStyle.bodySmall(fontWeight: fontWeight, color: color),
    );
  }

  Widget _caption() {
    return Text(
      text,
      textAlign: textAlign,
      style: BTextStyle.caption(color: color, fontWeight: fontWeight),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (textType) {
      case _BTextType.heading1:
        return _heading1();
      case _BTextType.heading2:
        return _heading2();
      case _BTextType.bodyLarge:
        return _bodyLarge();
      case _BTextType.bodyMedium:
        return _bodyMedium();
      case _BTextType.bodySmall:
        return _bodySmall();
      case _BTextType.caption:
        return _caption();
    }
  }
}

class BTextStyle {
  static TextStyle heading1({FontWeight? fontWeight, Color? color}) =>
      TextStyle(
          fontFamily: _fontName,
          fontWeight: fontWeight ?? FontWeightManager.bold,
          fontSize: 24,
          color: color ?? _ColorFontDefault.heading1);

  static TextStyle heading2({FontWeight? fontWeight, Color? color}) =>
      TextStyle(
          fontFamily: _fontName,
          fontWeight: fontWeight ?? FontWeightManager.semiBold,
          fontSize: 20,
          color: color ?? _ColorFontDefault.heading2);

  static TextStyle bodyLarge({FontWeight? fontWeight, Color? color}) =>
      TextStyle(
          fontFamily: _fontName,
          fontWeight: FontWeightManager.semiBold,
          fontSize: 18,
          color: color ?? _ColorFontDefault.bodyLarge);

  static TextStyle bodyMedium({FontWeight? fontWeight, Color? color}) =>
      TextStyle(
          fontFamily: _fontName,
          fontWeight: fontWeight ?? FontWeightManager.regular,
          fontSize: 16,
          color: color ?? _ColorFontDefault.bodyRegular);

  static TextStyle bodySmall({FontWeight? fontWeight, Color? color}) =>
      TextStyle(
          fontFamily: _fontName,
          fontWeight: fontWeight ?? FontWeightManager.regular,
          fontSize: 14,
          color: color ?? _ColorFontDefault.bodySmall);

  static TextStyle caption({FontWeight? fontWeight, Color? color}) => TextStyle(
      fontFamily: _fontName,
      fontWeight: fontWeight ?? FontWeightManager.medium,
      fontSize: 12,
      color: color ?? _ColorFontDefault.caption);
}

class FontWeightManager {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class _ColorFontDefault {
  static Color heading1 = ColorManager.primary;
  static Color heading2 = ColorManager.black;
  static Color bodyLarge = ColorManager.black;
  static Color bodyRegular = ColorManager.black;
  static Color bodySmall = ColorManager.grey;
  static Color caption = ColorManager.grey1;
}
