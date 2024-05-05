import 'package:collection/collection.dart';

enum TransactionType {
  increase(1),
  decrease(2);

  factory TransactionType.fromValue(int value) {
    return TransactionType.values.firstWhereOrNull((e) => e.value == value) ??
        TransactionType.increase;
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
