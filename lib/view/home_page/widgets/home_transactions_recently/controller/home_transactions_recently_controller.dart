import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/merge_model/budget_transaction_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeTransactionsRecentlyControllerProvider =
    StateNotifierProvider<HomeTransactionsRecentlyController, void>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionApi = ref.watch(transactionApiProvider);
  final db = ref.watch(dbProvider);
  return HomeTransactionsRecentlyController(
      transactionApi: transactionApi, uid: uid, db: db);
});

final homeTransactionsRecentlyFutureProvider =
    FutureProvider<List<BudgetTransactionModel>>((ref) {
  final controller = ref.watch(homeTransactionsRecentlyControllerProvider.notifier);
  return controller.getTransactionsRecently();
});

class HomeTransactionsRecentlyController
    extends StateNotifier<List<TransactionModel>> {
  HomeTransactionsRecentlyController(
      {required TransactionApi transactionApi,
      required String uid,
      required FirebaseFirestore db})
      : _transactionApi = transactionApi,
        _uid = uid,
        _db = db,
        super([]);
  final TransactionApi _transactionApi;
  final String _uid;
  final FirebaseFirestore _db;

  Future<List<BudgetTransactionModel>> getTransactionsRecently() async {
    List<TransactionModel> transactions =
        await _transactionApi.fetchTransactionsRecently(uid: _uid);
    if (transactions.isEmpty) {
      return [];
    }
    List<String> budgetIds = transactions.map((e) => e.budgetId).toList();
    List<BudgetModel> budgets = await _getBudgetsByIds(budgetIds: budgetIds);
    final list = BudgetTransactionModel.mapData(budgets: budgets, transactions: transactions);
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
}
