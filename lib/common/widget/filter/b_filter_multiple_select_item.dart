import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BFilterMultipleSelectItem<T> extends StatefulWidget {
  const BFilterMultipleSelectItem(
      {super.key,
      this.init,
      required this.values,
      required this.onChanged,
      required this.label});
  final List<T>? init;
  final List<T> values;
  final ValueChanged<List<T>?> onChanged;
  final String Function(T? model) label;

  @override
  State<BFilterMultipleSelectItem<T>> createState() =>
      _BFilterMultipleSelectItemState<T>();
}

class _BFilterMultipleSelectItemState<T>
    extends State<BFilterMultipleSelectItem<T>> {
  late List<T>? _currentValues;
  late List<T> _values;

  @override
  void initState() {
    _currentValues = widget.init;
    _values = widget.values;
    widget.onChanged(_currentValues);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _values.map((model) => _item(model)).toList(),
    );
  }

  Widget _item(T model) {
    String text = widget.label(model);
    bool isSelected = _currentValues?.contains(model) ?? false;
    return Card(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _currentValues?.remove(model);
            } else {
              _currentValues?.add(model);
            }
            widget.onChanged(_currentValues);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Theme.of(context).colorScheme.primary : null),
          child: BText(
            text,
            color: isSelected ? ColorManager.white : null,
          ),
        ),
      ),
    );
  }
}
