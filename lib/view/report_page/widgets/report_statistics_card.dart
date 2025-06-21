import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

class ReportStatisticsCard extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const ReportStatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final income = statistics['income'] as int;
    final expense = statistics['expense'] as int;
    final balance = statistics['balance'] as int;
    final transactionCount = statistics['transactionCount'] as int;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                gapW8,
                BText.b1(
                  context.loc.budgetSummary,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            gapH16,
            _buildStatisticsGrid(
                context, income, expense, balance, transactionCount),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, int income, int expense,
      int balance, int transactionCount) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatisticItem(
          context,
          title: context.loc.totalIncome,
          value: income.toMoneyStrContext(context),
          icon: Icons.trending_up,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        _buildStatisticItem(
          context,
          title: context.loc.totalExpense,
          value: expense.toMoneyStrContext(context),
          icon: Icons.trending_down,
          color: Theme.of(context).colorScheme.error,
        ),
        _buildStatisticItem(
          context,
          title: context.loc.netBalance,
          value: balance.toMoneyStrContext(context),
          icon: balance >= 0 ? Icons.account_balance_wallet : Icons.warning,
          color: balance >= 0
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.error,
        ),
        _buildStatisticItem(
          context,
          title: context.loc.transactions,
          value: transactionCount.toString(),
          icon: Icons.receipt_long,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildStatisticItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(100),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          gapH8,
          BText.b3(
            title,
            textAlign: TextAlign.center,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          gapH4,
          BText.b1(
            value,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            color: color,
          ),
        ],
      ),
    );
  }
}
