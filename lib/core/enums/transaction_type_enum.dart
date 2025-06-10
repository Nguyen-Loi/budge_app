import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';

enum TransactionTypeEnum {
  income('INCOME', BudgetTypeEnum.income),
  expense('EXPENSE', BudgetTypeEnum.expense),
  ;

  factory TransactionTypeEnum.fromValue(String value) {
    return TransactionTypeEnum.values.firstWhere((e) => e.value == value);
  }

  factory TransactionTypeEnum.fromAmount(int amount) {
    if (amount.sign == 0) {
      throw Exception('Not supported for this amount: $amount');
    }
    if (amount.sign == 1) {
      return TransactionTypeEnum.income;
    }
    return TransactionTypeEnum.expense;
  }

  final String value;
  final BudgetTypeEnum budgetType;
  const TransactionTypeEnum(this.value, this.budgetType);
}

extension BudgetTypeValue on TransactionTypeEnum {
  String content(BuildContext context) {
    switch (this) {
      case TransactionTypeEnum.income:
        return context.loc.income;
      case TransactionTypeEnum.expense:
        return context.loc.expense;
    }
  }

  String contentLoc(AppLocalizations loc) {
    switch (this) {
      case TransactionTypeEnum.income:
        return loc.income;
      case TransactionTypeEnum.expense:
        return loc.expense;
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
