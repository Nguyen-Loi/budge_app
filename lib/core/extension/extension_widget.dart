import 'package:budget_app/constants/size_constants.dart';
import 'package:flutter/material.dart';

extension WidgetReponsive on Widget {
  Widget responsiveCenter({
    double? width,
  }) {
    return Center(
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width ?? SizeConstants.maxWidthBase,
          ),
          child: this),
    );
  }
}

extension WidgetResponsivePadding on List<Widget> {
  List<Widget> responsiveCenter({
    double? width,
  }) {
    return map((widget) {
      return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width ?? SizeConstants.maxWidthBase,
            ),
            child: widget),
      );
    }).toList();
  }
}
