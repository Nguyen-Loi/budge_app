import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum TransactionTypeEnum {
  incomeBudget('INCOME_BUDGET'),
  incomeWallet('INCOME_WALLET'),
  expenseBudget('EXPENSE_BUDGET'),
  expenseWallet('EXPENSE_WALLET'),
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
  const TransactionTypeEnum(this.value);
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
}
