import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsBaseControllerProvider = StateNotifierProvider<
    TransactionsBaseController, List<TransactionCardModel>>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionApi = ref.watch(transactionApiProvider);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  return TransactionsBaseController(
      transactionApi: transactionApi,
      uid: uid,
      budgetController: budgetController);
});

final transactionsFutureProvider = FutureProvider((ref) {
  final controller = ref.watch(transactionsBaseControllerProvider.notifier);
  return controller.fetch();
});

class TransactionsBaseController
    extends StateNotifier<List<TransactionCardModel>> {
  TransactionsBaseController({
    required TransactionApi transactionApi,
    required BudgetBaseController budgetController,
    required String uid,
  })  : _transactionApi = transactionApi,
        _uid = uid,
        _budgetController = budgetController,
        super([]);
  final TransactionApi _transactionApi;
  final BudgetBaseController _budgetController;
  final String _uid;

  List<TransactionCardModel> _allCardTranctions = [];

  Future<List<TransactionCardModel>> fetch() async {
    final transactions = await _transactionApi.fetchTransaction(_uid);
    _allCardTranctions = await TransactionCardModel.transactionCard(
        transactions: transactions, budgets: _budgetController.getAll);

    if (_allCardTranctions.isEmpty) {
      return [];
    }
    _allCardTranctions.sort((a, b) =>
        b.transaction.transactionDate.compareTo(a.transaction.transactionDate));
    state = _allCardTranctions;
    return state;
  }

  void addState(TransactionModel model) {
    _allCardTranctions
        .insert(0,model.toTransactionCard(budgets: _budgetController.getAll));
    state = _allCardTranctions.toList();
  }
}
