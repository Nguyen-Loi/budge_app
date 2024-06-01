enum BudgetTypeEnum {
  budget('BUDGET'),
  debit('DEBIT'),;  

  factory BudgetTypeEnum.fromValue(String value) {
    return BudgetTypeEnum.values.firstWhere((e)=> e.value==value);
  }

  final String value;
  const BudgetTypeEnum(this.value);
}


