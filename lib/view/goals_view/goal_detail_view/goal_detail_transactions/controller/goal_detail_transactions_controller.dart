import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Get lastest transaction of this budget
final goalDetailTransactionsControllerProvider =
    StateNotifierProvider<GoalDetailTransactionsController, TransactionModel?>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final transactionApi = ref.watch(transactionApiProvider);
  return GoalDetailTransactionsController(transactionApi: transactionApi, uid: uid);
});

final goalDetailFutureProvider =
    FutureProvider.autoDispose.family((ref, String goalId) {
  final controller =
      ref.watch(goalDetailTransactionsControllerProvider.notifier);
  return controller.fetchListTransaction(goalId);
});

class GoalDetailTransactionsController extends StateNotifier<TransactionModel?> {
  final TransactionApi _transactionApi;
  final String _uid;
  GoalDetailTransactionsController(
      {required TransactionApi transactionApi, required String uid})
      : _transactionApi = transactionApi,
        _uid = uid,
        super(null);

  Future<List<TransactionModel>> fetchListTransaction(String goalId) async {
    final list = await _transactionApi.getTransactionsByBudgetId(
        uid: _uid, budgetId: goalId);
    list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    if (list.isNotEmpty) {
      state = list.first;
    }
    return list;
  }
}
