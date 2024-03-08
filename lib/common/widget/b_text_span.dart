import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BTextSpan extends TextSpan {
  BTextSpan(
      {VoidCallback? onTap,
      TextStyle? style,
      String? text,
      List<InlineSpan>? children})
      : super(
            text: text,
            children: children,
            recognizer: TapGestureRecognizer()..onTap = () => onTap?.call(),
            style: style ?? BTextStyle.bodyMedium());
}
