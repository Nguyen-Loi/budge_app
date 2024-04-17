import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/history_view/controller/history_controller.dart';
import 'package:budget_app/view/history_view/model/budget_transaction_custom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryItemTab extends StatelessWidget {
  const HistoryItemTab({super.key, required this.list});
  final List<BudgetTransactionCustomModel> list;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: Consumer(
            builder: (_, ref, __) => RefreshIndicator(
                  onRefresh: () => ref.refresh(historyFutureProvider.future),
                  child: list.isEmpty
                      ? const Center(
                          child:
                              BStatus.empty(text: 'There are no transactions'))
                      : ListViewWithSpacing(
                          children: list
                              .map((e) => Card(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: _card(e)),
                                  ))
                              .toList(),
                        ),
                )));
  }

  Widget _card(BudgetTransactionCustomModel model) {
    switch (model.transaction.transactionType) {
      case TransactionType.income:
        return _cardIncome(model.transaction);
      case TransactionType.expense:
        return _cardExpense(model);
    }
  }

  Widget _cardIncome(TransactionModel transaction) {
    return Row(
      children: [
        //Left
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BText(transaction.createdDate.toFormatDate()),
            gapH16,
            BText.b3(transaction.createdDate.toHHmm())
          ],
        )),
        gapW16,

        // Right
        BText('+ ${transaction.amount.toMoneyStr()}',
            color: ColorManager.green2)
      ],
    );
  }

  Widget _cardExpense(BudgetTransactionCustomModel model) {
    BudgetModel budget = model.budget!;
    return Row(
      children: [
        //Left
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BIcon(id: budget.iconId),
                gapW8,
                Expanded(child: BText.b1(budget.name)),
              ],
            ),
            gapH16,
            BText.b3(model.transaction.createdDate.toFormatDate())
          ],
        )),
        gapW16,

        // Right
        BText('- ${model.transaction.amount.toMoneyStr()}')
      ],
    );
  }
}
