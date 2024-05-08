import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionCardModel {
  final TransactionModel transaction;
  final String transactionName;
  final int iconId;
  TransactionCardModel({
    required this.transaction,
    required this.transactionName,
    required this.iconId,
  });

  static Future<List<TransactionCardModel>> transactionCard(
      {required List<TransactionModel> transactions,
      required String uid}) async {
    if (transactions.isEmpty) {
      return [];
    }

    // Get BudgetId in transaction not null
    List<String> budgetIds = transactions
        .map((e) => e.budgetId)
        .where((budgetId) => budgetId != null)
        .map((budgetId) => budgetId!)
        .toList();

    List<BudgetModel> budgets = [];
    if (budgetIds.isNotEmpty) {
      budgets = await _getBudgetsByIds(budgetIds: budgetIds, uid: uid);
    }
    final list = TransactionCardModel._mapData(
        budgets: budgets, transactions: transactions);
    return list;
  }

  static Future<List<BudgetModel>> _getBudgetsByIds(
      {required List<String> budgetIds, required String uid}) async {
    final data = await FirebaseFirestore.instance
        .collection(FirestorePath.budgets(uid: uid))
        .where('id', whereIn: budgetIds)
        .mapModel<BudgetModel>(
            modelFrom: BudgetModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  static List<TransactionCardModel> _mapData(
      {required List<BudgetModel> budgets,
      required List<TransactionModel> transactions}) {
    List<TransactionCardModel> list = [];
    for (var transaction in transactions) {
      // Handle transaciton type wallet
      TransactionCardModel transactionCard;
      if (transaction.budgetId == null) {
        int iconId;
        String transactionName;
        switch (transaction.transactionType) {
          case TransactionType.increase:
            iconId = 100;
            transactionName = 'Tiền chuyển đến'.hardcoded;
            break;
          case TransactionType.decrease:
            iconId = 101;
            transactionName = 'Tiền chuyển đi'.hardcoded;
            break;
        }
        transactionCard = TransactionCardModel(
            transaction: transaction,
            transactionName: transactionName,
            iconId: iconId);
      } else {
        final budget = budgets.firstWhere((e) => e.id == transaction.budgetId);
        transactionCard = TransactionCardModel(
            transaction: transaction,
            transactionName: budget.name,
            iconId: budget.iconId);
      }
      list.add(transactionCard);
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
