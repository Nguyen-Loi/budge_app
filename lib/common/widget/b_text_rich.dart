import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_span.dart';
import 'package:budget_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class BTextRich extends StatelessWidget {
  final InlineSpan? textSpan;
  final TextAlign? textAlign;
  final int? maxLines;
  const BTextRich(
    this.textSpan, {
    super.key,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textSpan!,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BTextRichSpace extends StatelessWidget {
  final String text1;
  final String text2;
  final TextStyle? styleText1;
  final TextStyle? styleText2;
  final VoidCallback? onTap;

  const BTextRichSpace(
      {super.key,
      required this.text1,
      required this.text2,
      this.onTap,
      this.styleText1,
      this.styleText2});
  @override
  Widget build(BuildContext context) {
    return BTextRich(
      BTextSpan(children: [
        BTextSpan(text: text1, style: styleText1),
        BTextSpan(
          text: text2,
          style: styleText1 ??
              BTextStyle.bodyMedium(color: ColorConstants.primary),
          onTap: onTap,
        ),
      ]),
      textAlign: TextAlign.end,
    );
  }
}
