import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';

class BFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconModel? iconModel;
  final ValueChanged<bool> onSelected;

  const BFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.iconModel,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: BText(
        label,
        color: selected ? Theme.of(context).colorScheme.onSecondary : null,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      avatar: iconModel == null
          ? null
          : Icon(
              iconModel!.data,
              color: iconModel!.color,
            ),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
