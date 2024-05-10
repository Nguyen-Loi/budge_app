import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';

class TransactionCardModel {
  final TransactionModel transaction;
  final String transactionName;
  final int iconId;
  TransactionCardModel({
    required this.transaction,
    required this.transactionName,
    required this.iconId,
  });

  static Future<List<TransactionCardModel>> transactionCard({
    required List<TransactionModel> transactions,
    required List<BudgetModel> budgets,
  }) async {
    if (transactions.isEmpty) {
      return [];
    }

    final list = TransactionCardModel._mapData(
        budgets: budgets, transactions: transactions);
    return list;
  }

  static List<TransactionCardModel> _mapData(
      {required List<BudgetModel> budgets,
      required List<TransactionModel> transactions}) {
    List<TransactionCardModel> list = [];
    for (var transaction in transactions) {
      // Handle transaciton type wallet

      list.add(transaction.toTransactionCard(budgets: budgets));
    }

    return list;
  }

  TransactionCardModel copyWith({
    TransactionModel? transaction,
    String? transactionName,
    int? iconId,
  }) {
    return TransactionCardModel(
      transaction: transaction ?? this.transaction,
      transactionName: transactionName ?? this.transactionName,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  String toString() =>
      'TransactionCardModel(transaction: $transaction, transactionName: $transactionName, iconId: $iconId)';
}
