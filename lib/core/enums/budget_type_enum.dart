enum BudgetTypeEnum {
  budget(1),
  goal(2);

  factory BudgetTypeEnum.fromValue(int value) {
    return BudgetTypeEnum.values
      .firstWhere((element) => element.value == value);
  }
  final int value;
  const BudgetTypeEnum(this.value);
}
