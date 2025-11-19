import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsBaseControllerProvider =
    NotifierProvider<TransactionsBaseController, List<TransactionCardModel>>(
        TransactionsBaseController.new);

class TransactionsBaseController extends Notifier<List<TransactionCardModel>> {
  late final TransactionRepository _transactionRepository;
  late final BudgetBaseController _budgetController;
  late final String _uid;
  List<TransactionCardModel> _allCardTranctions = [];

  @override
  List<TransactionCardModel> build() {
    _uid = ref.watch(uidControllerProvider).toString();
    _transactionRepository = ref.watch(transactionRepositoryProvider);
    _budgetController = ref.watch(budgetBaseControllerProvider.notifier);
    return [];
  }

  Future<List<TransactionCardModel>> fetch() async {
    final transactions = await _transactionRepository.fetchTransaction(_uid);
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
    _allCardTranctions.insert(
        0, model.toTransactionCard(budgets: _budgetController.getAll));
    state = _allCardTranctions.toList();
  }
}
