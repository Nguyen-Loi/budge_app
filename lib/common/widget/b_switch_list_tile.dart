import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BSwitchListTile extends StatelessWidget {
  const BSwitchListTile(
      {super.key,
      required this.onChanged,
      required this.value,
      required this.title});
  final void Function(bool)? onChanged;
  final bool value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        activeColor: Theme.of(context).colorScheme.secondary,
        title: BText(title),
        value: value,
        onChanged: onChanged);
  }
}
