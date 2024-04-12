import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_category_budget.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:budget_app/view/new_expense_view/controller/new_expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewExpenseView extends ConsumerStatefulWidget {
  const NewExpenseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends ConsumerState<NewExpenseView> {
  late TextEditingController _noteController;
  late TextEditingController _amountController;
  late String _budgetId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _noteController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      ref.read(expenseControllerProvider).addMoneyExpense(context,
          budgetId: _budgetId,
          amount: int.parse(_amountController.text),
          note: _noteController.text);
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
      list: ref.read(budgetsProvider),
      validator: (p0) {
        if (p0 == null) {
          return 'Please choose your budget';
        }
        return null;
      },
      onChanged: (budgetId) {
        _budgetId = budgetId;
      },
    );
  }

  Widget _buttonAddMoney() {
    return BButton(onPressed: _addExpense, title: 'Add money');
  }
}
