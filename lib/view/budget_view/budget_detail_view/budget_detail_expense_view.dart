import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_base_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailExpenseView extends BudgetBaseDetailView {
  const BudgetDetailExpenseView(
      {super.key, required super.budget, required super.transactions});

  @override
  List<Widget> header(BuildContext context, BudgetModel budget, WidgetRef ref) {
    bool isAllTime = budget.rangeDateTimeType == RangeDateTimeEnum.allTime;
    final progress = budget.budgetLimit > 0
        ? (budget.currentAmount / budget.budgetLimit).abs()
        : 0.0;
    final progressClamped = progress.clamp(0.0, 1.0);

    return [
      itemStatus(context),
      // Only show progress indicator for time-limited budgets
      if (!isAllTime && budget.budgetLimit > 0) ...[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withAlpha(100),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BText(
                    context.loc.spendingProgress,
                  ),
                  BText.b1(
                    '${(progressClamped * 100).toStringAsFixed(1)}%',
                    color: progress > 0.8
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressClamped,
                backgroundColor:
                    Theme.of(context).colorScheme.surface.withAlpha(150),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 1.0
                      ? Theme.of(context).colorScheme.error
                      : progress > 0.8
                          ? Colors.orange
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(200),
                ),
                minHeight: 8,
              ),
            ],
          ),
        ),
      ] else if (isAllTime) ...[
        // For all-time budgets, show a simple expense summary without progress
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.errorContainer.withAlpha(120),
                Theme.of(context).colorScheme.errorContainer.withAlpha(50),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withAlpha(50),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_down,
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
                      context.loc.totalExpense,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    BText(
                      budget.currentAmount.abs().toMoneyStr(ref),
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      itemRow(context,
          svgAsset: SvgAssets.money,
          label:
              isAllTime ? context.loc.totalExpense : context.loc.currentExpense,
          value: budget.currentAmount.toMoneyStr(ref),
          colorValue: Theme.of(context).colorScheme.error),
      // Only show limit for time-limited budgets
      if (!isAllTime && budget.budgetLimit > 0)
        itemRow(
          context,
          svgAsset: SvgAssets.limit,
          label: context.loc.limit,
          value: budget.budgetLimit.toMoneyStr(ref),
        ),
      itemOperatingTime(context)
    ];
  }
}
