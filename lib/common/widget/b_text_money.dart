import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:flutter/material.dart';

class BTextMoney extends StatelessWidget {
  final int value;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final FontStyle? fontStyle;

  const BTextMoney(
    this.value, {
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.fontStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BText.b1(
      value.toMoneyStr(isPrefix: true),
      color: value >= 0
          ? Theme.of(context).colorScheme.tertiary
          : Theme.of(context).colorScheme.error,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
         textAlign: textAlign,
    );
  }
}
