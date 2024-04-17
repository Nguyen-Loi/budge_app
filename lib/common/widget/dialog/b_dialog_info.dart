// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BDialogInfo {
  final String? title;
  final String message;
  final VoidCallback? onConfim;
  final String? textConfirm;
  final Color color;
  BDialogInfo(
      {this.title,
      required this.message,
      this.onConfim,
      this.textConfirm,
      required this.color});
}

Future<void> showBDialogInfoError(BuildContext context,
    {String? title,
    required String message,
    VoidCallback? onConfim,
    String? textConfirm}) {
  return BDialogInfo(
    message: message,
    title: title ?? 'Error',
    textConfirm: textConfirm,
    onConfim: onConfim,
    color: ColorManager.red,
  ).present(context);
}

extension Present<T> on BDialogInfo {
  Future<T?> present(BuildContext context) {
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: BText.b1(
            title!,
            fontWeight: FontWeight.bold,
          ),
          content: BText(message),
          actions: [
            TextButton(
              onPressed: onConfim ?? () => Navigator.of(context).pop(),
              child: BText(
                color: color,
                textConfirm ?? 'Confirm',
              ),
            )
          ],
        );
      },
    );
  }
}
