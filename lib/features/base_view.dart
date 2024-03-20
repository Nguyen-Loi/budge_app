import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BaseView extends StatelessWidget {
  const BaseView({Key? key, required this.title, required this.child}) : super(key: key);
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BText.h2(title),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
