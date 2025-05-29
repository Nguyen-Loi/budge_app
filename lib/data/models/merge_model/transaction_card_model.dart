import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionCardModel {
  final TransactionModel transaction;
  final String transactionName;
  final int iconId;
  final TransactionTypeEnum transactionType;
  TransactionCardModel({
    required this.transaction,
    required this.transactionName,
    required this.iconId,
    required this.transactionType,
  });

  static Future<List<TransactionCardModel>> transactionCard(
    AppLocalizations loc, {
    required List<TransactionModel> transactions,
    required List<BudgetModel> budgets,
  }) async {
    if (transactions.isEmpty) {
      return [];
    }

    final list = TransactionCardModel._mapData(loc,
        budgets: budgets, transactions: transactions);
    return list;
  }

  static List<TransactionCardModel> _mapData(AppLocalizations loc,
      {required List<BudgetModel> budgets,
      required List<TransactionModel> transactions}) {
    List<TransactionCardModel> list = [];
    for (var transaction in transactions) {
      list.add(transaction.toTransactionCard(loc, budgets: budgets));
    }

    return list;
  }

  TransactionCardModel copyWith({
    TransactionModel? transaction,
    String? transactionName,
    int? iconId,
    TransactionTypeEnum? transactionType,
  }) {
    return TransactionCardModel(
      transaction: transaction ?? this.transaction,
      transactionName: transactionName ?? this.transactionName,
      iconId: iconId ?? this.iconId,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  @override
  String toString() =>
      'TransactionCardModel(transaction: $transaction, transactionName: $transactionName, iconId: $iconId)';
}
