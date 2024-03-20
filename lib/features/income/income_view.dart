import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/picker/b_picker_datetime.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/features/base_view.dart';
import 'package:flutter/material.dart';

class IncomeView extends StatelessWidget {
  IncomeView({Key? key}) : super(key: key);

  DateTime get firstDate {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 10);
  }

  final TextEditingController _controllerAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: 'Income',
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ColumnWithSpacing(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BFormFieldText(
                _controllerAmount,
                label: 'Amount',
              ),
              BDropdown<String>(
                  title: 'Currency',
                  label: (v) => v.toString(),
                  items: const ['USD', 'VND'],
                  value: 'USD',
                  onChanged: (v) {}),
              BPickerDatetime(
                title: 'Date',
                firstDate: firstDate,
                onChanged: (date) {
                  logSuccess(date.toString());
                },
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BButton(
                        padding: const EdgeInsets.only(bottom: 16),
                        onPressed: () {},
                        title: 'Add money')),
              )
            ],
          ),
        ));
  }
}
