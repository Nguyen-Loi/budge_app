import 'package:budget_app/common/exception/custom_exception.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsBaseControllerProvider =
    NotifierProvider<TransactionsBaseController, List<BudgetTransactionsModel>>(
        TransactionsBaseController.new);

class TransactionsBaseController
    extends Notifier<List<BudgetTransactionsModel>> {
  late TransactionRepository _transactionRepository;
  late BudgetBaseController _budgetController;
  late String _uid;
  List<BudgetTransactionsModel> _budgetTranctions = [];

  @override
  List<BudgetTransactionsModel> build() {
    _uid = ref.watch(uidControllerProvider).toString();
    _transactionRepository = ref.watch(transactionRepositoryProvider);
    _budgetController = ref.watch(budgetBaseControllerProvider.notifier);
    return [];
  }

  Future<List<BudgetTransactionsModel>> fetch() async {
    final transactions = await _transactionRepository.fetchTransaction(_uid);
    transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

    _budgetTranctions =
        BudgetTransactionsModel.mapList(_budgetController.getAll, transactions);

    if (_budgetTranctions.isEmpty) {
      return [];
    }

    state = _budgetTranctions;
    return state;
  }

  void addState(TransactionModel model) {
    final budgetIndex = _budgetTranctions
        .indexWhere((element) => element.budget.id == model.budgetId);
    if (budgetIndex != -1) {
      final budgetTransaction = _budgetTranctions[budgetIndex];
      final updatedTransactions = [model, ...budgetTransaction.transactions];
      final updatedBudgetTransaction = BudgetTransactionsModel(
        budget: budgetTransaction.budget,
        transactions: updatedTransactions,
      );
      _budgetTranctions[budgetIndex] = updatedBudgetTransaction;
      state = _budgetTranctions.toList();
    } else {
      throw CustomException("Budget not found for transaction");
    }
  }
}
