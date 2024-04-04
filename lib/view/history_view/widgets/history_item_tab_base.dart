import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/view/history_view/model/budget_transaction_custom_model.dart';
import 'package:flutter/material.dart';

abstract class HistoryItemTabBase extends StatelessWidget {
  const HistoryItemTabBase({super.key});
  List<BudgetTransactionCustomModel> get budgetTransactions;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: ListViewWithSpacing(
          children: budgetTransactions
              .map((e) => Card(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: _card(e)),
                  ))
              .toList(),
        ));
  }

  Widget _card(BudgetTransactionCustomModel model) {
    return Row(
      children: [
        //Left
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BIcon(id: model.iconId),
                gapW8,
                Expanded(child: BText.b1(model.name)),
              ],
            ),
            gapH16,
            BText.b3(model.createdDate.toFormatDate())
          ],
        )),
        gapW16,

        // Right
        buildMoney(model.amountTransaction)
      ],
    );
  }

  Widget buildMoney(int amount);
}
