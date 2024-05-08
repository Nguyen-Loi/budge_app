import 'package:collection/collection.dart';

enum TransactionType {
  increase(1),
  decrease(2);

  factory TransactionType.fromValue(int value) {
    return TransactionType.values.firstWhereOrNull((e) => e.value == value) ??
        TransactionType.increase;
  }

  factory TransactionType.fromAmount(int amount){
    if (amount.sign==0){
      throw Exception('Not supported for this amount: $amount');
    }
    if(amount.sign==1){
      return TransactionType.increase;
    }
    return TransactionType.decrease;
  }

  final int value;
  const TransactionType(this.value);
}

extension ConvertTypeAccount on TransactionType {
  String toText() {
    switch (this) {
      case TransactionType.increase:
        return 'Income';
      case TransactionType.decrease:
        return 'Expense';
    }
  }
}
