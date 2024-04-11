import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_category_budget.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/data/data_local.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseView extends ConsumerStatefulWidget {
  const ExpenseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends ConsumerState<ExpenseView> {
  late TextEditingController _noteController;
  late TextEditingController _amountController;

  final List<BudgetModel> budgets = DataLocal.budgets;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _noteController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      logError('Success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: 'New expense',
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListViewWithSpacing(
              children: [
                _amount(),
                _note(),
                _chooseCategory(),
                gapH24,
                _buttonAddMoney()
              ],
            ),
          ),
        ));
  }

  Widget _note() {
    return BFormFieldText(_noteController, label: 'Note', maxLines: 2);
  }

  Widget _amount() {
    return BFormFieldAmount(
      _amountController,
      label: 'Amount',
      validator: (p0) => p0.validateAmount,
    );
  }

  Widget _chooseCategory() {
    return BFormCategoryBudget(
      label: 'Choose your budget',
      list: budgets,
      validator: (p0) {
        if (p0 == null) {
          return 'Please choose your budget';
        }
        return null;
      },
      onChanged: (budgetModel) {
        logSuccess(budgetModel.toString());
      },
    );
  }

  Widget _buttonAddMoney() {
    return BButton(onPressed: _addExpense, title: 'Add money');
  }
}
