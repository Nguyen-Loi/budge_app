import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetDetailControllerProvider = Provider((ref) {
  final uid = ref.watch(uidControllerProvider);
  final transactionApi = ref.watch(transactionApiProvider);
  return BudgetDetailController(transactionApi: transactionApi, uid: uid);
});

final fetchBudgetDetailController =
    FutureProvider.autoDispose.family((ref, String budgetId) {
  final controller = ref.watch(budgetDetailControllerProvider);
  return controller.fetchListTransaction(budgetId);
});

class BudgetDetailController extends StateNotifier<bool> {
  final TransactionApi _transactionApi;
  final String _uid;
  BudgetDetailController(
      {required TransactionApi transactionApi, required String uid})
      : _transactionApi = transactionApi,
        _uid = uid,
        super(false);

  Future<List<TransactionModel>> fetchListTransaction(String budgetId) {
    return _transactionApi.getTransactionsByBudgetId(
        uid: _uid, budgetId: budgetId);
  }
}
