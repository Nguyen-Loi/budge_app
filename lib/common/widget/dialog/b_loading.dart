import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

typedef CloseLoading = void Function();

CloseLoading showLoading({
  required BuildContext context,
  String text = 'Loading...',
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(LottieAssets.loading2),
        gapH16,
        BText(text),
      ],
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => dialog,
  );

  return () => Navigator.of(context).pop();
}
