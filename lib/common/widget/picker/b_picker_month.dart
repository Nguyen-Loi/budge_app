import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/type_def.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class BPickerMonth extends StatefulWidget {
  const BPickerMonth(
      {super.key,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      required this.onChange,
      this.hint = 'Picker your time'});
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return OutlinedButton(
        onPressed: () async {
          DateTime? dateTime = await showMonthPicker(
              context: context,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              initialDate: _dateTimePicker ?? DateTime.now(),
              selectableMonthPredicate: (p0) => true,
              monthPickerDialogSettings: MonthPickerDialogSettings(
                headerSettings: PickerHeaderSettings(
                  headerSelectedIntervalTextStyle:
                      Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                ),
                dialogSettings: PickerDialogSettings(
                  locale: Locale(ref.read(languageControllerProvider).code),
                ),
              ));
          if (dateTime != null) {
            setState(() {
              _dateTimePicker = dateTime;
            });
            widget.onChange(dateTime);
          }
        },
        child: BText.b1(_dateTimePicker == null
            ? widget.hint
            : _dateTimePicker.toFormatDate(strFormat: 'MM-yyyy')),
      );
    });
  }
}
