import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content,
    {Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: BText(
        content,
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          backgroundColor ?? Theme.of(context).extension<AppColors>()!.success,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

void showSnackBarError(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: BText(content),
      backgroundColor: Colors.red.shade600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
