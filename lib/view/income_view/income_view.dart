import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/picker/b_picker_datetime.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeView extends ConsumerWidget {
  IncomeView({Key? key}) : super(key: key);

  DateTime get firstDate {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 10);
  }

  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addMoney(WidgetRef ref){
   final data = ref.read(budgetAPIProvider).addBudget(name: name, iconId: iconId, limit: limit, startDate: startDate, endDate: endDate) 
  }


  Widget _form() {
    return Form(
      key: _formKey,
      child: ColumnWithSpacing(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BFormFieldAmount(
            _controllerAmount,
            label: 'Amount',
            hint: '',
            validator: (p0) => p0.validateInteger(textError: 'Amount invalid'),
          ),
          BFormFieldText(
            _controllerNote,
            maxLines: 2,
            label: 'Note',
            hint: 'Money from salary',
          ),
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
    );
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseView(
        title: 'Income',
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _form(),
        ));
  }
}
