import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/features/history/widgets/history_item_tab_base.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryItemTabExpense extends HistoryItemTabBase<TransactionModel> {
  const HistoryItemTabExpense({super.key, required this.transactions});
  final List<TransactionModel> transactions;

  @override
  Widget card(TransactionModel model) {
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
  List<TransactionModel> get list => transactions;
}
