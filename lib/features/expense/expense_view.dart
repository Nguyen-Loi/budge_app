import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/features/base_view.dart';
import 'package:budget_app/features/expense/widget/expense_category.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({Key? key}) : super(key: key);

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  final List<BudgetModel> listBudget = [
    BudgetModel({FieldConstants.name: 'Data 1', FieldConstants.iconId: 0}),
    BudgetModel({FieldConstants.name: 'Data 2', FieldConstants.iconId: 1}),
    BudgetModel({FieldConstants.name: 'Data 3', FieldConstants.iconId: 2}),
    BudgetModel({FieldConstants.name: 'Data 4', FieldConstants.iconId: 3}),
    BudgetModel({FieldConstants.name: 'Data 5', FieldConstants.iconId: 4}),
    BudgetModel({FieldConstants.name: 'Data 6', FieldConstants.iconId: 5}),
    BudgetModel({FieldConstants.name: 'Data 7', FieldConstants.iconId: 6}),
    BudgetModel({FieldConstants.name: 'Data 8', FieldConstants.iconId: 7}),
    BudgetModel({FieldConstants.name: 'Data 9', FieldConstants.iconId: 8}),
  ];

  @override
  void initState() {
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: 'New expense',
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListViewWithSpacing(
            children: [
              _fieldName(),
              _amountAndCurrency(),
              _chooseCategory(),
              gapH24,
              _buttonAddMoney()
            ],
          ),
        ));
  }

  Widget _fieldName() {
    return BFormFieldText(_nameController, label: 'Name');
  }

  Widget _amountAndCurrency() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: BFormFieldText(_amountController, label: 'Enter amount')),
        gapW16,
        Expanded(
            child: BDropdown(
                label: (v) => v.toString(),
                title: 'Currency',
                items: const ['USD', 'VND'],
                value: 'USD',
                onChanged: (v) {}))
      ],
    );
  }

  Widget _chooseCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BText.h2('Choose category'),
        gapH16,
        ExpenseCategory(
            list: listBudget,
            onChanged: (id) {
              logSuccess(id);
            })
      ],
    );
  }

  Widget _buttonAddMoney() {
    return BButton(onPressed: () {}, title: 'Add money');
  }
}
