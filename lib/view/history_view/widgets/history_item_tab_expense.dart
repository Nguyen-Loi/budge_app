import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/view/history_view/widgets/history_item_tab_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryItemTabExpense extends HistoryItemTabBase<BudgetTransactionModel> {
  const HistoryItemTabExpense({super.key, required this.transactions});
  final List<BudgetTransactionModel> transactions;

  @override
  Widget card(BudgetTransactionModel model) {
    return Row(
      children: [
        //Left
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BText.b1(model.createdAt.toFormatDate()),
            gapH8,
            BText.caption(model.createdAt.toHHmm())
          ],
        )),
        gapW16,

        // Right
        BText('- ${model.amount.toMoneyStr()}')
      ],
    );
  }

  @override
  List<BudgetTransactionModel> get list => transactions;
}
