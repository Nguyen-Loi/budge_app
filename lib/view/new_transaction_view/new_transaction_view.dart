import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_category_budget.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/picker/b_picker_datetime.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTransactionView extends ConsumerStatefulWidget {
  const NewTransactionView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends ConsumerState<NewTransactionView> {
  late TextEditingController _noteController;
  late int _amount;
  late String _budgetId;
  late DateTime _transactionDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _noteController = TextEditingController();
    super.initState();
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      ref.read(userBaseControllerProvider.notifier).addTransaction(
          context,
          budgetId: _budgetId,
          amount: _amount,
          note: _noteController.text,
          transactionDate: _transactionDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView.customBackground(
          buildTop: gapH32,
          title: 'New transaction',
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListViewWithSpacing(
                children: [
                  _amountField(),
                  _chooseBudgets(),
                  _note(),
                  _pickerDate(),
                  gapH24,
                  _buttonAddMoney()
                ],
              ),
            ),
          )),
    );
  }

  Widget _note() {
    return BFormFieldText(_noteController,
        label: context.loc.note, maxLines: 2);
  }

  Widget _amountField() {
    return BFormFieldAmount(
      label: context.loc.amount,
      onChanged: (v) {
        if (v != null) {
          _amount = v;
        }
      },
    );
  }

  Widget _pickerDate() {
    return BPickerDatetime(
        onChanged: (date) {
          _transactionDate = date;
        },
        title: context.loc.transactionDate);
  }

  Widget _chooseBudgets() {
    return BFormCategoryBudget(
      label: context.loc.chooseYourBudget,
      list: ref.watch(budgetBaseControllerProvider.notifier).getAll,
      validator: (p0) {
        if (p0 == null) {
          return context.loc.errorChooseYourBudget;
        }
        return null;
      },
      onChanged: (budgetId) {
        _budgetId = budgetId;
      },
    );
  }

  Widget _buttonAddMoney() {
    return BButton(onPressed: _addTransaction, title: context.loc.add);
  }
}
