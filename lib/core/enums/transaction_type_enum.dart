
enum TransactionTypeEnum {
  income('INCOME'),
  expense('EXPENSE');

  factory TransactionTypeEnum.fromValue(String value) {
    return TransactionTypeEnum.values
            .firstWhere((e) => e.value == value) ;
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
  const TransactionTypeEnum(this.value);
}

