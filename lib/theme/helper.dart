import 'package:flutter/material.dart';

extension ColorExt on Color {
  OutlineInputBorder get getOutlineBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(color: this, width: 0.5),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    );
  }
}
