import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: BText(content),
    ),
  );
}