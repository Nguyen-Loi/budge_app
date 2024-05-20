import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:flutter/material.dart';

class BButton extends StatelessWidget {
  const BButton(
      {super.key, required this.onPressed, required this.title, this.padding});
  final VoidCallback onPressed;
  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      constraints: const BoxConstraints(maxWidth: SizeConstants.maxWidthBase),
      child: FilledButton(
          onPressed: onPressed,
          clipBehavior: Clip.antiAlias,
          child: BText.b1(
            title,
            color: ColorManager.white,
          )),
    );
  }
}
