import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

enum _BTextType {
  headline1,
  headline2,
  headline3,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
}

class BText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final _BTextType _textType;
  final int? maxLines;
  final double? wordSpacing;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;

  const BText.h1(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.headline1;

  const BText.h2(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.headline2;

  const BText.h3(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.headline3;

  const BText.b1(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.bodyLarge;

  const BText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.bodyMedium;

  const BText.b3(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.bodySmall;

  const BText.caption(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.wordSpacing,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
    this.textDecoration,
    super.key,
  }) : _textType = _BTextType.caption;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: _getTextStyle(context),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    TextStyle? textStyle = switch (_textType) {
      _BTextType.headline1 => context.textTheme.headlineLarge!,
      _BTextType.headline2 => context.textTheme.headlineMedium!,
      _BTextType.headline3 => context.textTheme.headlineSmall!,
      _BTextType.bodyLarge => context.textTheme.bodyLarge!,
      _BTextType.bodyMedium => context.textTheme.bodyMedium!,
      _BTextType.bodySmall => context.textTheme.bodySmall!,
      _BTextType.caption => context.textTheme.labelLarge!,
    };
    return textStyle.copyWith(
        color: color,
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        height:
            textDecoration == TextDecoration.underline ? 1.5 : textStyle.height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: textDecoration);
  }
}
