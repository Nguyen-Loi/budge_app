import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

enum _TypeView { base, customBackground }

class BaseView extends StatelessWidget {
  const BaseView({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
  })  : _type = _TypeView.base,
        buildTop = null;
  const BaseView.customBackground(
      {super.key,
      required this.title,
      required this.buildTop,
      required this.child,
      this.floatingActionButton,
      this.actions})
      : _type = _TypeView.customBackground;
  final String title;
  final Widget child;
  final _TypeView _type;
  final Widget? buildTop;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _TypeView.base:
        return _base(context);
      case _TypeView.customBackground:
        return _customBackground(context);
    }
  }

  Widget _base(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BText.h3(title),
        actions: actions,
      ),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _customBackground(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BText.h3(title),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: ColoredBox(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            if (buildTop != null) buildTop!,
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: child),
            )
          ],
        ),
      ),
    );
  }
}
