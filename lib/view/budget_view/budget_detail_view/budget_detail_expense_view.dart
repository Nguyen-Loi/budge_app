import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_base_detail_view.dart';
import 'package:flutter/material.dart';

class BudgetDetailExpenseView extends BudgetBaseDetailView {
  const BudgetDetailExpenseView(
      {super.key, required super.budget, required super.transactions});

  @override
  List<Widget> header(BuildContext context, BudgetModel budget) {
    return [
      itemStatus(context),
      itemRow(context,
          svgAsset: SvgAssets.money,
          label: context.loc.currentExpense,
          value: budget.currentAmount.toMoneyStr(),
          colorValue: Theme.of(context).colorScheme.error),
      itemRow(
        context,
        svgAsset: SvgAssets.limit,
        label: context.loc.limit,
        value: budget.budgetLimit.toMoneyStr(),
      ),
      itemOperatingTime(context),
      itemReview(context)
    ];
  }
}
