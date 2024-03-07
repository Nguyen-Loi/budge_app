import 'package:budget_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

enum BTextType {
  heading1,
  heading2,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
}

class BText extends StatelessWidget {
  final String fontName = 'PublicSans';
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final BTextType textType;

  const BText.h1(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    super.key,
  }) : textType = BTextType.heading1;

  const BText.h2(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    super.key,
  }) : textType = BTextType.heading2;

  const BText.b1(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    super.key,
  }) : textType = BTextType.bodyLarge;

  const BText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    super.key,
  }) : textType = BTextType.bodyMedium;

  const BText.b3(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    super.key,
  }) : textType = BTextType.bodySmall;

  const BText.caption(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    super.key,
  }) : textType = BTextType.caption;

  Widget _heading1() {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fontName,
          fontWeight: fontWeight ?? _FontWeightManager.bold,
          fontSize: 24,
          color: color ?? _ColorFontDefault.heading1),
    );
  }

  Widget _heading2() {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fontName,
          fontWeight: fontWeight ?? _FontWeightManager.semiBold,
          fontSize: 20,
          color: color ?? _ColorFontDefault.heading2),
    );
  }

  Widget _bodyLarge() {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fontName,
          fontWeight: _FontWeightManager.semiBold,
          fontSize: 18,
          color: _ColorFontDefault.bodyLarge),
    );
  }

  Widget _bodyMedium() {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fontName,
          fontWeight: fontWeight ?? _FontWeightManager.regular,
          fontSize: 16,
          color: color ?? _ColorFontDefault.bodyRegular),
    );
  }

  Widget _bodySmall() {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fontName,
          fontWeight: fontWeight ?? _FontWeightManager.regular,
          fontSize: 14,
          color: color ?? _ColorFontDefault.bodySmall),
    );
  }

  Widget _caption() {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fontName,
          fontWeight: fontWeight ?? _FontWeightManager.medium,
          fontSize: 12,
          color: color ?? _ColorFontDefault.caption),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (textType) {
      case BTextType.heading1:
        return _heading1();
      case BTextType.heading2:
        return _heading2();
      case BTextType.bodyLarge:
        return _bodyLarge();
      case BTextType.bodyMedium:
        return _bodyMedium();
      case BTextType.bodySmall:
        return _bodySmall();
      case BTextType.caption:
        return _caption();
    }
  }
}

class _FontWeightManager {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class _ColorFontDefault {
  static Color heading1 = ColorConstants.darkGrey;
  static Color heading2 = ColorConstants.primary;
  static Color bodyLarge = ColorConstants.primary;
  static Color bodyRegular = ColorConstants.primary;
  static Color bodySmall = ColorConstants.darkGrey;
  static Color caption = ColorConstants.grey1;
}
