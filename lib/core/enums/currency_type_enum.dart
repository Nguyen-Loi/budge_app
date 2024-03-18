import 'package:collection/collection.dart';

enum CurrencyType {
  usd(1),
  vnd(2);
  
  static CurrencyType fromValue (int value){
    return  CurrencyType.values.firstWhereOrNull((e) => e.value==value)??CurrencyType.usd;
  }
  final int value;
  const CurrencyType(this.value);
}

extension ConvertTypeAccount on CurrencyType {
  String toText() {
    switch (this) {
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.vnd:
        return 'VND';
    }
  }
}
