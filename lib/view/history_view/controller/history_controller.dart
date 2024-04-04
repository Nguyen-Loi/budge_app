import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/data/data_local.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/history_view/model/budget_transaction_custom_model.dart';

class HistoryController {
  final List<BudgetModel> _budgets = DataLocal.budgets;
  final List<BudgetTransactionCustomModel> _budgetTransaction = [];
  void init() {
    loadData();
  }

  void loadData() {
    _budgetTransaction.clear();
    List<BudgetModel> temp = _budgets.toList();
    for (var a in temp) {
      for (var b in a.transactions) {
        _budgetTransaction
            .add(BudgetTransactionCustomModel.from(budget: a, transaction: b));
      }
    }
  }

  List<BudgetTransactionCustomModel> get budgetsIncome => _budgetTransaction
      .where((element) => element.transactionType == TransactionType.income)
      .toList();

  List<BudgetTransactionCustomModel> get budgetsExpense => _budgetTransaction
      .where((element) => element.transactionType == TransactionType.expense)
      .toList();
}
