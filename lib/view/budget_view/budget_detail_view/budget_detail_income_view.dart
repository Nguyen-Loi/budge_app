import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_base_detail_view.dart';
import 'package:flutter/material.dart';

class BudgetDetailIncomeView extends BudgetBaseDetailView {
  const BudgetDetailIncomeView(
      {super.key, required super.budget, required super.transactions});

  @override
  List<Widget> header(BuildContext context, BudgetModel budget) {
    bool isAllTime = budget.rangeDateTimeType == RangeDateTimeEnum.allTime;

    return [
      itemStatus(context),
      // Income summary card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.tertiaryContainer.withAlpha(120),
              Theme.of(context).colorScheme.tertiaryFixed.withAlpha(50),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(50),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.surface,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BText(
                    isAllTime
                        ? context.loc.totalIncome
                        : context.loc.currentIncome,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  BText(
                    budget.currentAmount.toMoneyStr(),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Show progress indicator for time-limited budgets with limits
      if (!isAllTime && budget.budgetLimit > 0) ...[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.tertiaryContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(100),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BText(
                    'Income Progress',
                  ),
                  BText.b1(
                    '${((budget.currentAmount.abs() / budget.budgetLimit * 100).clamp(0, 100)).toStringAsFixed(1)}%',
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (budget.currentAmount.abs() / budget.budgetLimit)
                    .clamp(0.0, 1.0),
                backgroundColor:
                    Theme.of(context).colorScheme.surface.withAlpha(150),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.tertiary,
                ),
                minHeight: 8,
              ),
            ],
          ),
        ),
      ],
      itemRow(context,
          svgAsset: SvgAssets.money,
          label:
              isAllTime ? context.loc.totalIncome : context.loc.currentIncome,
          value: budget.currentAmount.toMoneyStrTruncated(),
          colorValue: Theme.of(context).colorScheme.tertiary),
      // Only show limit for time-limited budgets
      if (!isAllTime && budget.budgetLimit > 0)
        itemRow(
          context,
          svgAsset: SvgAssets.limit,
          label: context.loc.limit,
          value: budget.budgetLimit.toMoneyStrTruncated(),
        ),
      itemOperatingTime(context)
    ];
  }
}
