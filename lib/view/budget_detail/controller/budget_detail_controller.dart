import 'package:budget_app/apis/budget_transaction_api.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetDetailControllerProvider = Provider((ref) {
  final uid = ref.watch(uidProvider);
  final budgetTransactionApi = ref.watch(budgetTransactionApiProvider);
  return BudgetDetailController(
      budgetTransactionApi: budgetTransactionApi, uid: uid);
});

final fetchBudgetDetailController =
    FutureProvider.autoDispose.family((ref, String budgetId) {
  final controller = ref.watch(budgetDetailControllerProvider);
  return controller.fetchListTransaction(budgetId);
});

class BudgetDetailController extends StateNotifier<bool> {
  final BudgetTransactionApi _budgetTransactionApi;
  final String _uid;
  BudgetDetailController(
      {required BudgetTransactionApi budgetTransactionApi, required String uid})
      : _budgetTransactionApi = budgetTransactionApi,
        _uid = uid,
        super(false);

  Future<List<BudgetTransactionModel>> fetchListTransaction(String budgetId) {
    return _budgetTransactionApi.getBudgetTransactionsById(
        uid: _uid, budgetId: budgetId);
  }
}
