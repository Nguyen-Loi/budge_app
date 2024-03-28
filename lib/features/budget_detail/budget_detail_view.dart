import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/view/budget_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
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
      title: budget.name,
      buildTop: _buildTop(),
      child: _body(),
    );
  }

  Widget _buildTop() {
    Color textColor = ColorManager.white;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText.h1('Monthly Expense', color: ColorManager.white),
          gapH16,
          Row(
            children: [
              BText('You\'ve spent ', color: textColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: ColorManager.purple15,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: BText('\$60', color: textColor),
              ),
              BText(' for the past 7 days', color: textColor)
            ],
          ),
          gapH16
        ],
      ),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        _status(),
        gapH24,
        _transactions(),
      ],
    );
  }

  Widget _status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BText.h2('Transactions', textAlign: TextAlign.left),
        gapH16,
        listGroupTransactionByDay.isEmpty
            ? _transactionEmpty()
            : ColumnWithSpacing(
                spacing: 24,
                children: listGroupTransactionByDay
                    .map((e) => _groupDateTransactionsCard(e))
                    .toList(),
              )
      ],
    );
  }

  Widget _transactionEmpty() {
    return const BStatus.empty(text: 'You don\'t have any transactions yet');
  }

  Widget _groupDateTransactionsCard(
      _GroupDateTransactionModel groupDateTransactionModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(groupDateTransactionModel.dateTime.toFormatDate()),
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
                            Expanded(
                                child: BText(
                                    e.description.isEmpty
                                        ? budget.name
                                        : e.description,
                                    fontWeight: FontWeightManager.semiBold)),
                            gapW16,
                            _itemStatusTransaction(type: e.transactionType)
                          ],
                        ),
                        gapH16,
                        Row(
                          children: [
                            Expanded(
                              child: BText.b3(
                                e.createdAt.toHHmm(),
                              ),
                            ),
                            gapW16,
                            _itemMoneyTransaction(
                                type: e.transactionType, amount: e.amount)
                          ],
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

  Widget _itemStatusTransaction({required TransactionType type}) {
    switch (type) {
      case TransactionType.expense:
        return const BText.caption('Expense');
      case TransactionType.income:
        return const BText.caption('Income');
    }
  }

  Widget _itemMoneyTransaction(
      {required TransactionType type, required int amount}) {
    switch (type) {
      case TransactionType.expense:
        return BText('-$amount',
            color: ColorManager.red, fontWeight: FontWeightManager.bold);
      case TransactionType.income:
        return BText('+$amount',
            color: ColorManager.green1, fontWeight: FontWeightManager.bold);
    }
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
      if (transaction.createdAt == null) {
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
