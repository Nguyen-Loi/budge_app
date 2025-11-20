import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';

class ChartBudgetModel {
  final String? budgetId;
  final String budgetName;
  final double value;
  final String iconName;
  final int total;
  final int? incomeAmount; // Add income tracking
  final int? expenseAmount; // Add expense tracking

  ChartBudgetModel({
    required this.budgetId,
    required this.budgetName,
    required this.value,
    required this.iconName,
    required this.total,
    this.incomeAmount,
    this.expenseAmount,
  });

  // Convenience getters
  bool get hasIncome => (incomeAmount ?? 0) > 0;
  bool get hasExpense => (expenseAmount ?? 0) > 0;
  bool get isIncomeOnly => hasIncome && !hasExpense;
  bool get isExpenseOnly => !hasIncome && hasExpense;
  bool get isMixed => hasIncome && hasExpense;

  int get netAmount => (incomeAmount ?? 0) - (expenseAmount ?? 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'budgetId': budgetId,
      'budgetName': budgetName,
      'value': value,
      'iconName': iconName,
      'total': total,
      'incomeAmount': incomeAmount,
      'expenseAmount': expenseAmount,
    };
  }

  static List<ChartBudgetModel> toList(
      {required List<BudgetTransactionsModel> budgetTransaction,
      required List<TransactionTypeEnum> transactionTypes}) {
    List<ChartBudgetModel> list = [];

    final filterBudgetTransaction = budgetTransaction
        .map((e) {
          final filteredTransactions = e.transactions
              .where((tx) => transactionTypes.contains(tx.transactionType))
              .toList();

          return BudgetTransactionsModel(
            budget: e.budget,
            transactions: filteredTransactions,
          );
        })
        .where((e) => e.transactions.isNotEmpty)
        .toList();

    for (var e in filterBudgetTransaction) {
      final List<TransactionModel> transactions = e.transactions;
      final budget = e.budget;
      int incomeAmount = transactions
          .where((element) =>
              element.transactionType == TransactionTypeEnum.income)
          .fold<int>(0, (total, element) => total + element.amount);

      int expenseAmount = transactions
          .where((element) =>
              element.transactionType == TransactionTypeEnum.expense)
          .fold<int>(0, (total, element) => total + element.amount.abs());

      int totalAmount;
      if (transactionTypes.contains(TransactionTypeEnum.income) &&
          transactionTypes.contains(TransactionTypeEnum.expense)) {
        totalAmount = incomeAmount - expenseAmount;
      } else if (transactionTypes.contains(TransactionTypeEnum.income)) {
        totalAmount = incomeAmount;
      } else {
        totalAmount = expenseAmount;
      }

      // Only add items that have transactions for the selected types
      bool hasRelevantTransactions = false;
      if (transactionTypes.contains(TransactionTypeEnum.income) &&
          incomeAmount > 0) {
        hasRelevantTransactions = true;
      }
      if (transactionTypes.contains(TransactionTypeEnum.expense) &&
          expenseAmount > 0) {
        hasRelevantTransactions = true;
      }

      if (hasRelevantTransactions && totalAmount != 0) {
        final model = ChartBudgetModel(
          budgetId: budget.id,
          budgetName: budget.name,
          value: 0,
          iconName: budget.iconName,
          total: totalAmount,
          incomeAmount: incomeAmount > 0 ? incomeAmount : null,
          expenseAmount: expenseAmount > 0 ? expenseAmount : null,
        );
        list.add(model);
      }
    }

    int totalSum = list.fold(0, (total, item) => total + item.total.abs());

    List<ChartBudgetModel> updatedList = [];
    for (ChartBudgetModel item in list) {
      if (totalSum > 0) {
        final double avgItem = ((item.total.abs() / totalSum) * 100);
        updatedList.add(item.copyWith(value: avgItem));
      }
    }

    // Sort by value for better visualization
    updatedList.sort((a, b) => b.value.compareTo(a.value));

    return updatedList;
  }

  @override
  String toString() {
    return 'ChartBudgetModel(budgetId: $budgetId, budgetName: $budgetName, value: $value, iconName: $iconName, total: $total)';
  }

  ChartBudgetModel copyWith({
    String? budgetId,
    String? budgetName,
    double? value,
    String? iconName,
    int? total,
    int? incomeAmount,
    int? expenseAmount,
  }) {
    return ChartBudgetModel(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      value: value ?? this.value,
      iconName: iconName ?? this.iconName,
      total: total ?? this.total,
      incomeAmount: incomeAmount ?? this.incomeAmount,
      expenseAmount: expenseAmount ?? this.expenseAmount,
    );
  }

  @override
  bool operator ==(covariant ChartBudgetModel other) {
    if (identical(this, other)) return true;

    return other.budgetId == budgetId &&
        other.budgetName == budgetName &&
        other.value == value &&
        other.iconName == iconName &&
        other.total == total &&
        other.incomeAmount == incomeAmount &&
        other.expenseAmount == expenseAmount;
  }

  @override
  int get hashCode {
    return budgetId.hashCode ^
        budgetName.hashCode ^
        value.hashCode ^
        iconName.hashCode ^
        total.hashCode ^
        incomeAmount.hashCode ^
        expenseAmount.hashCode;
  }
}
