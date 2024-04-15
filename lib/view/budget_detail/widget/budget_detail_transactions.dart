import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/async/b_async_list.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/budget_detail/controller/budget_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailTransactions extends ConsumerWidget {
  const BudgetDetailTransactions(this.budgetId, {super.key});
  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fetchBudgetDetailController(budgetId));
    return BListAsync.customList(
        data: data,
        itemsBuilder: (context, items) {
          List<_GroupDateTransactionModel> listGroupTransactionByDay =
              _GroupDateTransactionModel.toList(items);
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
        });
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
                                child: BText(e.note,
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
                                e.createdDate.toHHmm(),
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

  Widget _transactionEmpty() {
    return const BStatus.empty(text: 'You don\'t have any transactions yet');
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
    String amountMoney = amount.toMoneyStr();
    switch (type) {
      case TransactionType.expense:
        return BText('-$amountMoney',
            color: ColorManager.red, fontWeight: FontWeightManager.bold);
      case TransactionType.income:
        return BText('+$amountMoney',
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
      DateTime date = DateTime(transaction.createdDate.year,
          transaction.createdDate.month, transaction.createdDate.day);
      if (groupedTransactions[date] == null) {
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
