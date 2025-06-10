import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailTransactions extends ConsumerWidget {
  const BudgetDetailTransactions(this.transactions, {super.key});
  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = transactions;
    List<_GroupDateTransactionModel> listGroupTransactionByDay =
        _GroupDateTransactionModel.toList(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        listGroupTransactionByDay.isEmpty
            ? _transactionEmpty(context)
            : ColumnWithSpacing(
                spacing: 24,
                children: listGroupTransactionByDay
                    .map((e) => _groupDateTransactionsCard(context, e))
                    .toList(),
              )
      ],
    );
  }

  Widget _groupDateTransactionsCard(BuildContext context,
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
                                child: BText(e.note.isEmpty
                                    ? context.loc.noData
                                    : e.note)),
                            gapW16,
                            BText.caption(e.transactionType.content(context))
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
                            _itemMoneyTransaction(context,
                                type: e.transactionType, amount: e.amount.abs())
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

  Widget _transactionEmpty(BuildContext context) {
    return BStatus.empty(text: context.loc.noTransactionDescription);
  }

  Widget _itemMoneyTransaction(BuildContext context,
      {required TransactionTypeEnum type, required int amount}) {
    String amountMoney = amount.toMoneyStr();
    switch (type) {
      case TransactionTypeEnum.income:
        return BText('+$amountMoney',
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w700);
      case TransactionTypeEnum.expense:
        return BText('-$amountMoney',
            color: ColorManager.red1, fontWeight: FontWeight.w700);
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
