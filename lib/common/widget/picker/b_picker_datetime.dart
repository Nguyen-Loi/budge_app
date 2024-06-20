import 'package:budget_app/common/type_def.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:flutter/material.dart';

class BPickerDatetime extends StatefulWidget {
  const BPickerDatetime(
      {super.key,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      required this.onChanged,
      required this.title});
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final OnChangeDate onChanged;
  final String title;

  @override
  State<BPickerDatetime> createState() => _BPickerDatetimeState();
}

class _BPickerDatetimeState extends State<BPickerDatetime> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    DateTime initValue = widget.initialDate ?? DateTime.now();
    String? strFormat = initValue.toFormatDate();
    widget.onChanged(initValue);

    _textEditingController = TextEditingController(text: strFormat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          widget.title,
          fontWeight: FontWeight.w700,
        ),
        gapH8,
        TextField(
          focusNode: _AlwaysDisabledFocusNode(),
          controller: _textEditingController,
          onTap: () {
            _selectDate(context);
          },
          decoration: InputDecoration(
            suffix: Icon(IconManager.calendar),
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.firstDate ?? now.subtract(const Duration(days: 7)),
      lastDate: widget.lastDate ?? now.add(const Duration(days: 7)),
    );

    if (newSelectedDate != null) {
      _textEditingController.text = newSelectedDate.toFormatDate();
      widget.onChanged(newSelectedDate);
    }
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
