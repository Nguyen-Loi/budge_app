import 'package:budget_app/common/type_def.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/utils/b_date_time.dart';
import 'package:flutter/material.dart';

class BPickerDatetime extends StatefulWidget {
  const BPickerDatetime(
      {Key? key,
      this.initialDate,
      required this.firstDate,
      this.lastDate,
      required this.onChanged})
      : super(key: key);
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime? lastDate;
  final OnChangeDate onChanged;

  @override
  State<BPickerDatetime> createState() => _BPickerDatetimeState();
}

class _BPickerDatetimeState extends State<BPickerDatetime> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    DateTime initValue = widget.initialDate ?? DateTime.now();
    String? strFormat = BDateTime.toFormat(initValue);
    widget.onChanged(initValue);

    _textEditingController = TextEditingController(text: strFormat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _AlwaysDisabledFocusNode(),
      controller: _textEditingController,
      onTap: () {
        _selectDate(context);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(IconConstants.calendar),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate ?? DateTime.now(),
    );

    if (newSelectedDate != null) {
      _textEditingController.text = BDateTime.toFormat(newSelectedDate);
      widget.onChanged(newSelectedDate);
    }
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
