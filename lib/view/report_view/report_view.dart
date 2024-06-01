import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/chart_budget.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Báo cáo'.hardcoded,
      child: ListView(
        children: const [
          // ChartBudget(list: list),
          gapH16,
        ],
      ),
    );
  }

  Widget _cardBudget(BuildContext context,
      {required BudgetTransactionsModel budgetTransactions}) {
    final budget = budgetTransactions.budget;
    final transactions = budgetTransactions.transactions;
    return ExpansionTile(
        leading: BIcon(id: budget.iconId),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
        title: BText(budget.name, fontWeight: FontWeight.w700),
        trailing: BText(
          budget.currentAmount.toMoneyStr(),
          color: IconManagerData.getIconModel(budget.iconId).color,
        ),
        children: transactions
            .map((e) => ListTile(
                  title: BText(e.transactionDate.toFormatDate()),
                  subtitle: e.note.isEmpty
                      ? null
                      : BText(
                          e.note,
                          fontStyle: FontStyle.italic,
                        ),
                ))
            .toList());
  }
}
