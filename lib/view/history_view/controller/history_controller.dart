import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/history_view/model/budget_transaction_custom_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyControllerProvider =
    StateNotifierProvider<HistoryController, void>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final transactionApi = ref.watch(transactionApiProvider);
  final db = ref.watch(dbProvider);
  return HistoryController(transactionApi: transactionApi, uid: uid, db: db);
});

final historyFutureProvider =
    FutureProvider<List<BudgetTransactionCustomModel>>((ref) {
  final controller = ref.watch(historyControllerProvider.notifier);
  return controller.getTransactionByMonth();
});

class HistoryController extends StateNotifier<void> {
  HistoryController(
      {required TransactionApi transactionApi,
      required String uid,
      required FirebaseFirestore db})
      : _transactionApi = transactionApi,
        _uid = uid,
        _db = db,
        super(null);
  final TransactionApi _transactionApi;
  final String _uid;
  final FirebaseFirestore _db;

  DateTime _dateTimePicker = DateTime.now();
  DateTime get dateTimePicker => _dateTimePicker;
  void updateDate(DateTime date) {
    _dateTimePicker = date;
  }

  Future<List<BudgetTransactionCustomModel>> getTransactionByMonth() async {
    List<TransactionModel> transactions = await _transactionApi
        .fetchTransactionOfMonth(uid: _uid, dateTime: dateTimePicker);
    if (transactions.isEmpty) {
      return [];
    }
    List<String> budgetIds = transactions.map((e) => e.budgetId).toList();
    List<BudgetModel> budgets = await _getBudgetsByIds(budgetIds: budgetIds);
    final list = _mapData(budgets: budgets, transactions: transactions);
    return list;
  }

  Future<List<BudgetModel>> _getBudgetsByIds(
      {required List<String> budgetIds}) async {
    final data = await _db
        .collection(FirestorePath.budgets(uid: _uid))
        .where('id', whereIn: budgetIds)
        .mapModel<BudgetModel>(
            modelFrom: BudgetModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  List<BudgetTransactionCustomModel> _mapData(
      {required List<BudgetModel> budgets,
      required List<TransactionModel> transactions}) {
    List<BudgetTransactionCustomModel> list = [];
    for (var transaction in transactions) {
      if (transaction.transactionType == TransactionType.income) {
        final data = BudgetTransactionCustomModel(
            budget: null, transaction: transaction);
        list.add(data);
        continue;
      }
      final budget = budgets.firstWhere((e) =>
          transaction.transactionType == TransactionType.expense &&
          transaction.budgetId == e.id);
      final data = BudgetTransactionCustomModel(
          budget: budget, transaction: transaction);
      list.add(data);
    }
    return list;
  }
}
