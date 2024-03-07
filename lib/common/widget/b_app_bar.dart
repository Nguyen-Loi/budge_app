import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BAppBar extends AppBar {
  BAppBar({
    super.key,
    required String text,
  }) : super(title: BText.h2(text), centerTitle: true);
}
