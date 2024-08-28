import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum BudgetTypeEnum {
  income('INCOME'),
  expense('EXPENSE'),
  incomeWallet('INCOME_WALLET'),
  expenseWallet('EXPENSE_WALLET'),
  ;

  factory BudgetTypeEnum.fromValue(String value) {
    return BudgetTypeEnum.values.firstWhere((e) => e.value == value);
  }

  factory BudgetTypeEnum.fromAmount(int amount) {
    if (amount.sign == 0) {
      throw Exception('Not supported for this amount: $amount');
    }
    if (amount.sign == 1) {
      return BudgetTypeEnum.incomeWallet;
    }
    return BudgetTypeEnum.expenseWallet;
  }

  final String value;
  const BudgetTypeEnum(this.value);
}

extension BudgetTypeValue on BudgetTypeEnum {
  String content(BuildContext context) {
    switch (this) {
      case BudgetTypeEnum.incomeWallet:
      case BudgetTypeEnum.income:
        return context.loc.income;
      case BudgetTypeEnum.expense:
      case BudgetTypeEnum.expenseWallet:
        return context.loc.expense;
    }
  }
}
