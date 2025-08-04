import 'package:budget_app/common/widget/b_lottie.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';

typedef CloseLoading = void Function();

CloseLoading showLoading({
  required BuildContext context,
  String text = 'Loading...',
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
            child: BLottie(LottieUrl.loading2)),
        gapH16,
        BText.b1(text, fontWeight: FontWeight.bold),
      ],
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => dialog,
  );

  return () {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  };
}
