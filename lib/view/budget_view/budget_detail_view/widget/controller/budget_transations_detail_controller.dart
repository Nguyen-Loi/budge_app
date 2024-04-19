import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Get lastest transaction of this budget
final budgetTransactionDetailControllerProvider =
    StateNotifierProvider<BudgetTransactionsDetailController, TransactionModel?>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final transactionApi = ref.watch(transactionApiProvider);
  return BudgetTransactionsDetailController(transactionApi: transactionApi, uid: uid);
});

final budgetDetailFutureProvider =
    FutureProvider.autoDispose.family((ref, String budgetId) {
  final controller =
      ref.watch(budgetTransactionDetailControllerProvider.notifier);
  return controller.fetchListTransaction(budgetId);
});

class BudgetTransactionsDetailController extends StateNotifier<TransactionModel?> {
  final TransactionApi _transactionApi;
  final String _uid;
  BudgetTransactionsDetailController(
      {required TransactionApi transactionApi, required String uid})
      : _transactionApi = transactionApi,
        _uid = uid,
        super(null);

  Future<List<TransactionModel>> fetchListTransaction(String budgetId) async {
    final list = await _transactionApi.getTransactionsByBudgetId(
        uid: _uid, budgetId: budgetId);
    list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    if (list.isNotEmpty) {
      state = list.first;
    }
    return list;
  }
}
