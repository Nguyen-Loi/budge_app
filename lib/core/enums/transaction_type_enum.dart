import 'package:collection/collection.dart';

enum TransactionTypeEnum {
  increase(1),
  decrease(2);

  factory TransactionTypeEnum.fromValue(int value) {
    return TransactionTypeEnum.values
            .firstWhereOrNull((e) => e.value == value) ??
        TransactionTypeEnum.increase;
  }

  factory TransactionTypeEnum.fromAmount(int amount) {
    if (amount.sign == 0) {
      throw Exception('Not supported for this amount: $amount');
    }
    if (amount.sign == 1) {
      return TransactionTypeEnum.increase;
    }
    return TransactionTypeEnum.decrease;
  }

  final int value;
  const TransactionTypeEnum(this.value);
}

extension ConvertTypeAccount on TransactionTypeEnum {
  String toText() {
    switch (this) {
      case TransactionTypeEnum.increase:
        return 'Income';
      case TransactionTypeEnum.decrease:
        return 'Expense';
    }
  }
}
