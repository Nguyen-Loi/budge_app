import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BAppBar extends AppBar {
  BAppBar(
    BuildContext context, {
    super.key,
    required String text,
  }) : super(
          title: BText.h1(text),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
}
