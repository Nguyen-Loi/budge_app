import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_base_detail_view.dart';
import 'package:flutter/material.dart';

class BudgetDetailIncomeView extends BudgetBaseDetailView {
  const BudgetDetailIncomeView(
      {super.key, required super.budget, required super.transactions});

  @override
  List<Widget> header(BuildContext context, BudgetModel budget) {
    return [
      _currentIncome(context),
      gapH8,
      BText.b3(strTime(context, model: budget)),
    ];
  }

  Widget _currentIncome(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: '${context.loc.currentIncome}: ',
        style: context.textTheme.bodyMedium!,
      ),
      TextSpan(
        text: budget.currentAmount.toMoneyStr(),
        style: context.textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w700),
      )
    ]));
  }
}
