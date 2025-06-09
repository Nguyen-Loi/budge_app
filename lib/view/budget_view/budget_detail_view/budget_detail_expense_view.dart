import 'package:budget_app/common/widget/b_text.dart';
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
    final progress = budget.budgetLimit > 0
        ? (budget.currentAmount / budget.budgetLimit).abs()
        : 0.0;
    final progressClamped = progress.clamp(0.0, 1.0);

    return [
      itemStatus(context),
      // Progress indicator for expenses
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
                  'Spending Progress',
                  fontWeight: FontWeight.w500,
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
                        : Theme.of(context).colorScheme.primary.withAlpha(200),
              ),
              minHeight: 8,
            ),
          ],
        ),
      ),
      itemRow(context,
          svgAsset: SvgAssets.money,
          label: context.loc.currentExpense,
          value: budget.currentAmount.toMoneyStrTruncated(),
          colorValue: Theme.of(context).colorScheme.error),
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
