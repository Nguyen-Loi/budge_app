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
