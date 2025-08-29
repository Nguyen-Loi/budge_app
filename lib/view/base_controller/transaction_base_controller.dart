import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsBaseControllerProvider = StateNotifierProvider<
    TransactionsBaseController, List<TransactionCardModel>>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  return TransactionsBaseController(
    transactionRepository: transactionRepository,
    uid: uid,
    budgetController: budgetController,
  );
});

class TransactionsBaseController
    extends StateNotifier<List<TransactionCardModel>> {
  TransactionsBaseController({
    required TransactionRepository transactionRepository,
    required BudgetBaseController budgetController,
    required String uid,
  })  : _transactionRepository = transactionRepository,
        _uid = uid,
        _budgetController = budgetController,
        super([]);
  final TransactionRepository _transactionRepository;
  final BudgetBaseController _budgetController;
  final String _uid;

  List<TransactionCardModel> _allCardTranctions = [];

  Future<List<TransactionCardModel>> fetch() async {
    final transactions = await _transactionRepository.getAllByUserId(_uid);
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
