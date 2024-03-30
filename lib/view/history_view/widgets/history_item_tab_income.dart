import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/view/history_view/widgets/history_item_tab_base.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryItemTabIncome extends HistoryItemTabBase<BudgetModel> {
  const HistoryItemTabIncome({super.key, required this.budgets});
  final List<BudgetModel> budgets;

  @override
  Widget card(BudgetModel model) {
    return Row(
      children: [
        //Left
        Expanded(
            child: Row(
          children: [
            BIcon(id: model.iconId),
            gapW8,
            Column(
              children: [
                BText.b1(model.name),
                gapH8,
                BText.caption('${model.transactions.length} transactions')
              ],
            )
          ],
        )),
        gapW16,

        // Right
        BText('+ ${model.currentAmount.toMoneyStr()}',
            color: ColorManager.green1)
      ],
    );
  }

  @override
  List<BudgetModel> get list => budgets;
}
