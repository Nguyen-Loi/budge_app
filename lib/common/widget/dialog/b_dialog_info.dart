import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum DialogInfoType { error, success }

class BDialogInfo {
  final String? title;
  final String message;
  final VoidCallback? onSubmit;
  final String? textSubmit;
  final DialogInfoType dialogInfoType;
  final IconData? icon;
  BDialogInfo({
    this.title,
    required this.message,
    this.onSubmit,
    this.textSubmit,
    this.icon,
    required this.dialogInfoType,
  });
}

Future<void> showBDialogInfoError(BuildContext context,
    {String? title,
    required String message,
    VoidCallback? onConfirm,
    String? textSubmit}) {
  return BDialogInfo(
    message: message,
    title: title,
    textSubmit: textSubmit,
    onSubmit: onConfirm,
    dialogInfoType: DialogInfoType.error,
  ).present(context);
}

extension Present<T> on BDialogInfo {
  Future<T?> present(
    BuildContext context,
  ) {
    IconData bIcon;
    String bTextConfirm;
    String bTitle;
    Color bColor;
    switch (dialogInfoType) {
      case DialogInfoType.error:
        bIcon = icon ?? IconManager.emojiFrown;
        bTextConfirm = textSubmit ?? context.loc.close;
        bTitle = title ?? context.loc.errorUp;
        bColor = ColorManager.red2;
      case DialogInfoType.success:
        bIcon = icon ?? IconManager.success;
        bTextConfirm = textSubmit ?? context.loc.continueText;
        bTitle = title ?? context.loc.successUp;
        bColor = ColorManager.green1;
    }
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 2, color: bColor)),
              child: Icon(
                icon ?? bIcon,
                color: bColor,
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BText.h2(bTitle, letterSpacing: 3),
              gapH8,
              BText.b3(message)
            ],
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: bColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 64)),
              onPressed: onSubmit ?? () => Navigator.of(context).pop(),
              child: BText.b1(
                bTextConfirm,
                color: ColorManager.white,
              ),
            )
          ],
        );
      },
    );
  }
}
