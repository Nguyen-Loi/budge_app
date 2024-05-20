enum BudgetTypeEnum {
  increase(1),
  decrease(2);

  factory BudgetTypeEnum.fromValue(int value) {
    return BudgetTypeEnum.values.firstWhere((e)=> e.value==value);
  }


  final int value;
  const BudgetTypeEnum(this.value);
}

extension ConvertTypeAccount on BudgetTypeEnum {
  String toText() {
    switch (this) {
      case BudgetTypeEnum.increase:
        return 'Income';
      case BudgetTypeEnum.decrease:
        return 'Expense';
    }
  }
}
