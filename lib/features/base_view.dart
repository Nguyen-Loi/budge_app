import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

enum _TypeView { base, customBackground }

class BaseView extends StatelessWidget {
  const BaseView({Key? key, required this.title, required this.child})
      : _type = _TypeView.base,
        buildTop = null,
        super(
          key: key,
        );
  const BaseView.customBackground({
    Key? key,
    required this.title,
    required this.buildTop,
    required this.child,
  })  : _type = _TypeView.customBackground,
        super(
          key: key,
        );
  final String title;
  final Widget child;
  final _TypeView _type;
  final Widget? buildTop;
  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _TypeView.base:
        return _base();
      case _TypeView.customBackground:
        return _customBackground();
    }
  }

  Widget _base() {
    return Scaffold(
      appBar: AppBar(
        title: BText.h2(title),
        centerTitle: true,
      ),
      body: child,
    );
  }

  Widget _customBackground() {
    Color colorAppbar = ColorManager.white;
    return Scaffold(
      appBar: AppBar(
        title: BText.h2(title, color: colorAppbar),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorAppbar),
        backgroundColor: ColorManager.purple12,
      ),
      body: ColoredBox(
        color: ColorManager.purple12,
        child: Column(
          children: [
            if (buildTop != null) buildTop!,
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: ColorManager.white,
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
