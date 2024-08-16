import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum BDialogInfoType { error, success, warning }

class BDialogInfo {
  final String? title;
  final String message;
  final VoidCallback? onSubmit;
  final String? textSubmit;
  final BDialogInfoType dialogInfoType;
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

// class BDialogAction {
//   final String? title;
//   final String? message;
//   final VoidCallback? onSubmit;
//   final String? textSubmit;
//   final DialogInfoType dialogInfoType;
//   final IconData? icon;
// }

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
    dialogInfoType: BDialogInfoType.error,
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
      case BDialogInfoType.error:
        bIcon = icon ?? IconManager.emojiFrown;
        bTextConfirm = textSubmit ?? context.loc.close;
        bTitle = title ?? context.loc.errorUp;
        bColor = ColorManager.red2;
      case BDialogInfoType.success:
        bIcon = icon ?? IconManager.success;
        bTextConfirm = textSubmit ?? context.loc.continueText;
        bTitle = title ?? context.loc.successUp;
        bColor = Theme.of(context).colorScheme.tertiary;
      case BDialogInfoType.warning:
        bIcon = icon ?? IconManager.warning;
        bTextConfirm = textSubmit ?? context.loc.close;
        bTitle = title ?? 'Warning';
        bColor = ColorManager.yellow;
    }
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return _baseDialog(context,
            bColor: bColor,
            bIcon: bIcon,
            bTitle: bTitle,
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: bColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 64)),
                onPressed: onSubmit ?? () => Navigator.of(context).pop(),
                child: BText.b1(
                  bTextConfirm,
                  color: ColorManager.white,
                ),
              )
            ]);
      },
    );
  }

  Widget _baseDialog(BuildContext context,
      {required Color bColor,
      required IconData bIcon,
      required String bTitle,
      required List<Widget> actions}) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
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
      actions: actions,
    );
  }
}
