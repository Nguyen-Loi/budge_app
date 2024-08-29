import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum BudgetTypeEnum {
  income('INCOME'),
  expense('EXPENSE'),
  ;

  factory BudgetTypeEnum.fromValue(String value) {
    return BudgetTypeEnum.values.firstWhere((e) => e.value == value);
  }


  final String value;
  const BudgetTypeEnum(this.value);
}

extension BudgetTypeValue on BudgetTypeEnum {
  String content(BuildContext context) {
    switch (this) {
      case BudgetTypeEnum.income:
        return context.loc.income;
      case BudgetTypeEnum.expense:
        return context.loc.expense;
    }
  }
}
