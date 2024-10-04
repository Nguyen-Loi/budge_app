import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class BAnimatedText extends StatelessWidget {
  const BAnimatedText(this.text, {super.key, this.fontSize});
  final double? fontSize;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: context.textTheme.bodyMedium!.copyWith(
            fontSize: fontSize,
          ),
          speed: const Duration(milliseconds: 200),
        ),
      ],
      totalRepeatCount: 4,
      pause: const Duration(milliseconds: 200),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}
