import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/picker/b_picker_datetime.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:budget_app/view/income_view/controller/income_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeView extends ConsumerStatefulWidget {
  const IncomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IncomeViewState();
}

class _IncomeViewState extends ConsumerState<IncomeView> {
  DateTime get firstDate {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 10);
  }

  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  late DateTime _transactionDate;
  final _formKey = GlobalKey<FormState>();

  void _addMoney({required String uid}) {
    if (_formKey.currentState!.validate()) {
      ref.read(incomeControllerProvider).addMoney(context,
          uid: uid,
          amount: int.parse(_controllerAmount.text).toAmountMoney(),
          transactionDate: _transactionDate,
          note: _controllerNote.text);
    }
  }

  Widget _form(BuildContext context) {
    String uid = ref.watch(uidControllerProvider);
    return Form(
      key: _formKey,
      child: ListViewWithSpacing(
        children: [
          BFormFieldAmount(
            _controllerAmount,
            label: context.loc.amount,
            hint: '',
            validator: (p0) => p0.validateInteger(textError: context.loc.amountInvalid),
          ),
          BFormFieldText(
            _controllerNote,
            maxLines: 2,
            label: context.loc.note,
            hint: context.loc.noteHint,
          ),
          BPickerDatetime(
            title: context.loc.date,
            firstDate: firstDate,
            onChanged: (date) {
              _transactionDate = date;
            },
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height / 5),
          BButton(
              padding: const EdgeInsets.only(bottom: 16),
              onPressed: () => _addMoney(uid: uid),
              title: context.loc.addMoney)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView(
          title: context.loc.income,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _form(context),
          )),
    );
  }
}
