import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/color_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T?) label;
  final String? hint;

  const BDropdown({
    Key? key,
    this.value,
    this.hint,
    required this.label,
    required this.items,
    required this.onChanged,
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorConstants.grey, width: 0.4)),
      child: DropdownButton<T>(
        value: value,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        underline: const SizedBox.shrink(),
        hint: widget.hint == null
            ? BText('Empty', color: ColorConstants.grey1)
            : BText(widget.hint!, color: ColorConstants.grey1),
        icon: Icon(
          IconConstants.dropdown,
          color: ColorConstants.black,
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
            child: Text(widget.label(value).toString()),
          );
        }).toList(),
      ),
    );
  }
}
