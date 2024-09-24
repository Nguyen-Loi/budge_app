import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TransactionTypeEnum {
  incomeBudget('INCOME_BUDGET', BudgetTypeEnum.income),
  incomeWallet('INCOME_WALLET', BudgetTypeEnum.income),
  expenseBudget('EXPENSE_BUDGET', BudgetTypeEnum.expense),
  expenseWallet('EXPENSE_WALLET', BudgetTypeEnum.expense),
  ;

  factory TransactionTypeEnum.fromValue(String value) {
    return TransactionTypeEnum.values.firstWhere((e) => e.value == value);
  }

  factory TransactionTypeEnum.fromAmount(int amount) {
    if (amount.sign == 0) {
      throw Exception('Not supported for this amount: $amount');
    }
    if (amount.sign == 1) {
      return TransactionTypeEnum.incomeWallet;
    }
    return TransactionTypeEnum.expenseWallet;
  }

  final String value;
  final BudgetTypeEnum budgetType;
  const TransactionTypeEnum(this.value, this.budgetType);
}

extension BudgetTypeValue on TransactionTypeEnum {
  String content(BuildContext context) {
    switch (this) {
      case TransactionTypeEnum.incomeWallet:
        return context.loc.incomeWallet;
      case TransactionTypeEnum.incomeBudget:
        return context.loc.incomeBudget;
      case TransactionTypeEnum.expenseBudget:
        return context.loc.expenseBudget;
      case TransactionTypeEnum.expenseWallet:
        return context.loc.expenseWallet;
    }
  }

  String contentLoc(AppLocalizations loc) {
    switch (this) {
      case TransactionTypeEnum.incomeWallet:
        return loc.incomeWallet;
      case TransactionTypeEnum.incomeBudget:
        return loc.incomeBudget;
      case TransactionTypeEnum.expenseBudget:
        return loc.expenseBudget;
      case TransactionTypeEnum.expenseWallet:
        return loc.expenseWallet;
    }
  }
}

extension BudgetTypeListValue on List<TransactionTypeEnum> {
  bool get isOnlyContainIncomeOrExpense {
    bool isHasIncome = any((e) => e.budgetType == BudgetTypeEnum.income);
    bool isHasExpense = any((e) => e.budgetType == BudgetTypeEnum.expense);
    return !(isHasIncome && isHasExpense);
  }
}
