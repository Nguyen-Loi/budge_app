import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BTextMoney extends StatelessWidget {
  final int value;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final FontStyle? fontStyle;
  final WidgetRef? ref;
  final double? fontSize;

  const BTextMoney(
    this.value, {
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.fontStyle,
    this.ref,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String currencySymbol = ref == null
        ? value.toMoneyStrContext(context, isPrefix: true)
        : value.toMoneyStr(ref!, isPrefix: true);
    return Text(
      currencySymbol,
      textAlign: textAlign,
      style: context.textTheme.bodyMedium?.copyWith(
        color: value == 0
            ? Theme.of(context).colorScheme.onSurfaceVariant
            : value >= 0
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.error,
        fontWeight: fontWeight ?? FontWeight.w700,
        fontStyle: fontStyle,
        fontSize: fontSize,
      ),
    );
  }
}
