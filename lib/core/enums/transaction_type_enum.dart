import 'package:collection/collection.dart';

enum TransactionType {
  income(1),
  expense(2);
  
  static TransactionType fromValue (int value){
    return  TransactionType.values.firstWhereOrNull((e) => e.value==value)??TransactionType.income;
  }

  final int value;
  const TransactionType(this.value);  
}

extension ConvertTypeAccount on TransactionType {
  String toText() {
    switch (this) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
    }
  }
}
