import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_base_detail_view.dart';
import 'package:flutter/material.dart';

class BudgetDetailIncomeView extends BudgetBaseDetailView {
  const BudgetDetailIncomeView(
      {super.key, required super.budget, required super.transactions});

  @override
  List<Widget> header(BuildContext context, BudgetModel budget) {
    return [
      itemStatus(context),
      itemRow(context,
          svgAsset: SvgAssets.money,
          label: context.loc.currentIncome,
          value: budget.currentAmount.toMoneyStr(),
          colorValue: Theme.of(context).colorScheme.tertiary),
      itemOperatingTime(context),
      itemReview(context)
    ];
  }
}
