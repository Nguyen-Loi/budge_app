enum StatusBudgetEnum {
  progress(1),
  done(2),
  delete(3);

  factory StatusBudgetEnum.fromValue(int value) {
    return StatusBudgetEnum.values
        .firstWhere((element) => element.value == value);
  }
  final int value;
  const StatusBudgetEnum(this.value);
}