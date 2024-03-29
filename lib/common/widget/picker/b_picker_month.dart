import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/type_def.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class BPickerMonth extends StatefulWidget {
  const BPickerMonth(
      {Key? key,
      this.initialDate,
      required this.onChange,
      this.hint = 'Picker your time'})
      : super(key: key);
  final DateTime? initialDate;
  final OnChangeDate onChange;
  final String hint;

  @override
  State<BPickerMonth> createState() => _BPickerMonthState();
}

class _BPickerMonthState extends State<BPickerMonth> {
  DateTime? _dateTimePicker;
  @override
  void initState() {
    _dateTimePicker = widget.initialDate;
    if (_dateTimePicker != null) {
      widget.onChange(_dateTimePicker!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? dateTime = await showMonthPicker(
          headerColor: ColorManager.primary,
          context: context,
          initialDate: _dateTimePicker ?? DateTime.now(),
        );
        if (dateTime != null) {
          setState(() {
            _dateTimePicker = dateTime;
          });
          widget.onChange(dateTime);
        }
      },
      child: BText.b1(_dateTimePicker == null
          ? widget.hint
          : _dateTimePicker.toFormatDate()),
    );
  }
}
