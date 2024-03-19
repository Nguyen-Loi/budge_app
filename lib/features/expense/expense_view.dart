import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({Key? key}) : super(key: key);

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacing(
      children: const [],
    );
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
                items: const ['USD', 'VND'],
                value: 'USD',
                onChanged: (v) {}))
      ],
    );
  }

  Widget _chooseCategory(){
    return Column(
      children: [
        BText.h2('Choose category'),
        gapW16,
        
      ],
    )
  }
}
