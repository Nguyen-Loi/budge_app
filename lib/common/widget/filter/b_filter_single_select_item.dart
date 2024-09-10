import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BFilterSingleSelectItem<T> extends StatefulWidget {
  const BFilterSingleSelectItem({
    super.key,
    required this.init,
    required this.values,
    required this.onChanged,
    required this.label,
  });

  final T? init;
  final List<T> values;
  final ValueChanged<T?> onChanged;
  final String Function(T? model) label;

  @override
  State<BFilterSingleSelectItem<T>> createState() =>
      _BFilterSingleSelectItemState<T>();
}

class _BFilterSingleSelectItemState<T>
    extends State<BFilterSingleSelectItem<T>> {
  late T? _currentValue;
  late List<T> _values;

  @override
  void initState() {
    _currentValue = widget.init;
    _values = widget.values;
    widget.onChanged(_currentValue);

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
    bool isSelected = model == _currentValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentValue = model;
          widget.onChanged(_currentValue);
        });
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          child: BText(
            text,
            color: isSelected ? ColorManager.white : null,
          ),
        ),
      ),
    );
  }
}
