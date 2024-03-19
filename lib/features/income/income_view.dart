import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/picker/b_picker_datetime.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const BText.h2('Income'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ColumnWithSpacing(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BFormFieldText(
              _controllerAmount,
              label: 'Amount',
            ),
            BDropdown<String>(
                label: (v) => v.toString(),
                items: const ['USD', 'VND'],
                onChanged: (v) {}),
            BPickerDatetime(
              firstDate: firstDate,
              onChanged: (date) {
                logSuccess(date.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}
