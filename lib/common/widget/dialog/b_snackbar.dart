import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: BText(
        content,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSnackBarError(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: BText(content),
      backgroundColor: Colors.red.shade600,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
