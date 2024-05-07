import 'package:flutter/material.dart';

class BBottomSheet {
  static Future<void> show(BuildContext context,{required Widget Function(BuildContext) builder}) {
    return showModalBottomSheet(
      context: context,
      builder: builder
    );
  }
}
