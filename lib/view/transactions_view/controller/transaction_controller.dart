import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider =
    StateNotifierProvider<TransactionsController, List<TransactionCardModel>>(
        (ref) {
  final transactionBase = ref.watch(transactionsBaseControllerProvider);
  return TransactionsController(transactionsState: transactionBase);
});

class TransactionsController extends StateNotifier<List<TransactionCardModel>> {
  TransactionsController({
    required List<TransactionCardModel> transactionsState,
  })  : _transactionBase = transactionsState,
        super([]) {
    updateDate(_dateTimePicker);
  }
  final List<TransactionCardModel> _transactionBase;

  DateTime firstDateTransactions = DateTime.now();
  DateTime lastDateTransactions = DateTime.now();

  DateTime _dateTimePicker = DateTime.now();
  DateTime get dateTimePicker => _dateTimePicker;

  int _sumIncome = 0;
  int _sumExpense = 0;
  int get sumIncome => _sumIncome;
  int get sumExpense => _sumExpense;

  void updateDate(DateTime date) {
    _dateTimePicker = date;
    state = _transactionBase
        .filterByMonth(
            time: _dateTimePicker,
            getDate: (x) => x.transaction.transactionDate)
        .toList();

    _caculator();
  }

  void _caculator() {
    int newIncome = 0;
    int newExpense = 0;
    for (var e in state) {
      switch (e.transaction.budgetType) {
        case BudgetTypeEnum.income:
        case BudgetTypeEnum.incomeWallet:
          newIncome += e.transaction.amount;
          break;
        case BudgetTypeEnum.expense:
        case BudgetTypeEnum.expenseWallet:
          newExpense += e.transaction.amount;
          break;
      }
    }
    _sumIncome = newIncome;
    _sumExpense = newExpense;
  }
}
