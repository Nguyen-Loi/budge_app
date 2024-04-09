
import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

typedef CloseLoading = void Function();

CloseLoading showLoading({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
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