import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/view/budget_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/features/base_view.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:flutter/material.dart';

class BudgetDetailView extends StatelessWidget {
  const BudgetDetailView({Key? key, required this.budget}) : super(key: key);
  final BudgetModel budget;
  @override
  Widget build(BuildContext context) {
    return BaseView.customBackground(
      title: 'Shopping',
      buildTop: _buildTop(),
      child: _body(),
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        BText.h1('Monthly Expense', color: ColorManager.white),
        gapH16,
        Row(
          children: [
            const BText('You\'ve spent '),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: ColorManager.purple15,
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: const BText('\$60'),
            ),
            const BText(' for the past 7 days')
          ],
        )
      ],
    );
  }

  Widget _body() {
    return Column(
      children: [
        _status(),
        gapH24,
        _transactions(),
      ],
    );
  }

  Widget _status() {
    return Column(
      children: [
        // info
        Row(
          children: [
            BText.b3('You\'ve already spent', color: ColorManager.grey),
            gapW16,
            const Expanded(
                child: BText.b3('Spend limit per Month',
                    textAlign: TextAlign.end)),
          ],
        ),
        gapH8,
        //number
        Row(
          children: [
            BText.h2('60', color: ColorManager.blue),
            gapW16,
            const Expanded(child: BText.h2('\$120', textAlign: TextAlign.end)),
          ],
        ),
        gapH16,
        // Status
        BudgetStatus(budget: budget),
        gapH8,
        // Content
        const BText.b3('Cool! Let\'t keep your expense below the limit.')
      ],
    );
  }

  Widget _transactions() {
    List<_GroupDateTransactionModel> listGroupTransactionByDay =
        _GroupDateTransactionModel.toList(budget.transactions);
    return Column(
      children: [
        const BText.h2('Transactions'),
        gapH16,
        ColumnWithSpacing(
          children: listGroupTransactionByDay
              .map((e) => _groupDateTransactionsCard(e))
              .toList(),
        )
      ],
    );
  }

  Widget _groupDateTransactionsCard(
      _GroupDateTransactionModel groupDateTransactionModel) {
    return Column(
      children: [
        BText(groupDateTransactionModel.dateTime.toFormat()),
        gapH8,
        ColumnWithSpacing(
          spacing: 8,
          children: groupDateTransactionModel.transactions
              .map(
                (e) => Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: BText.b1('Table')),
                            gapW16,
                            BText('-${e.amount}',
                                color: ColorManager.red,
                                fontWeight: FontWeightManager.bold)
                          ],
                        ),
                        gapH16,
                        if (e.description != '') BText.caption(e.description),
                        BText.b3(
                          e.createdAt.toFormat(strFormat: 'hh:mm'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}

class _GroupDateTransactionModel {
  _GroupDateTransactionModel({
    required this.transactions,
    required this.dateTime,
  });
  final List<TransactionModel> transactions;
  final DateTime dateTime;

 // Create a map to group transactions by date
  static List<_GroupDateTransactionModel> toList(
      List<TransactionModel> transactions) {
  
    Map<DateTime, List<TransactionModel>> groupedTransactions = {};
    for (var transaction in transactions) {
      if(transaction.createdAt==null){
        continue;
      }
      DateTime date = DateTime(transaction.createdAt!.year,
          transaction.createdAt!.month, transaction.createdAt!.day);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    List<_GroupDateTransactionModel> result =
        groupedTransactions.entries.map((entry) {
      return _GroupDateTransactionModel(
        transactions: entry.value,
        dateTime: entry.key,
      );
    }).toList();

    return result;
  }
}
