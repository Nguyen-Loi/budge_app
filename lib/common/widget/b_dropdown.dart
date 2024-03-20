import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T?) label;
  final String? hint;
  final String? title;

  const BDropdown({
    Key? key,
    this.value,
    this.hint,
    required this.label,
    required this.items,
    required this.onChanged,
    this.title,
  }) : super(key: key);

  @override
  State<BDropdown<T?>> createState() => _BDropdownState<T>();
}

class _BDropdownState<T> extends State<BDropdown<T?>> {
  late T? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.title == null ? _itemDropdown() : _itemDropdownWithTitle();
  }

  Widget _itemDropdownWithTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          widget.title!,
          fontWeight: FontWeightManager.semiBold,
        ),
        gapH8,
        _itemDropdown(),
      ],
    );
  }

  Widget _itemDropdown() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border.all(color: ColorManager.grey, width: 0.4)),
      child: DropdownButton<T>(
        value: value,
        dropdownColor: Theme.of(context).colorScheme.onSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        underline: const SizedBox.shrink(),
        hint: widget.hint == null
            ? BText('Empty', color: ColorManager.grey1)
            : BText(widget.hint!, color: ColorManager.grey1),
        icon: Icon(
          IconConstants.dropdown,
          color: ColorManager.black,
        ),
        elevation: 16,
        onChanged: (T? v) {
          if (value != null) {
            setState(() {
              value = v;
              widget.onChanged(v);
            });
          }
        },
        items: widget.items.map<DropdownMenuItem<T>>((T? value) {
          return DropdownMenuItem<T>(
            value: value,
            child: BText(widget.label(value).toString()),
          );
        }).toList(),
      ),
    );
  }
}
