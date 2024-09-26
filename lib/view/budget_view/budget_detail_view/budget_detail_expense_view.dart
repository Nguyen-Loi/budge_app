import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/custom/budget_expense_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_base_detail_view.dart';
import 'package:flutter/material.dart';

class BudgetDetailExpenseView extends BudgetBaseDetailView {
  const BudgetDetailExpenseView(
      {super.key, required super.budget, required super.transactions});

  @override
  List<Widget> header(BuildContext context, BudgetModel budget) {
    return [
      _sendLimitPerMonth(context),
      gapH8,
      _moneys(context, budget),
      gapH16,
      BudgetExpenseStatus(budget: budget),
      gapH8,
      BText.b3(budget.getReview(context)),
      BText.b3(strTime(context, model: budget)),
    ];
  }

  Widget _sendLimitPerMonth(BuildContext context) {
    return Row(
      children: [
        BText.b3(context.loc.currentExpense),
        gapW16,
        Expanded(
            child: BText.b3(context.loc.spendLimitPerMonth,
                textAlign: TextAlign.end)),
      ],
    );
  }

  Widget _moneys(BuildContext context, BudgetModel model) {
    return Row(
      children: [
        BText.h3(model.currentAmount.toMoneyStr(),
            color: Theme.of(context).colorScheme.secondary),
        gapW16,
        Expanded(
            child:
                BText.h3(model.limit.toMoneyStr(), textAlign: TextAlign.end)),
      ],
    );
  }
}
