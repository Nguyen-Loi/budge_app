import 'package:flutter/material.dart';

const double _radius = 10.0;

extension ColorExt on Color {
  OutlineInputBorder get getOutlineBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(color: this, width: 2.3),
      borderRadius: const BorderRadius.all(
        Radius.circular(_radius),
      ),
    );
  }

  OutlineInputBorder get getEnabledBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(color: this, width: 0.7),
      borderRadius: const BorderRadius.all(
        Radius.circular(_radius),
      ),
    );
  }
}
