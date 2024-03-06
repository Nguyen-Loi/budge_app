import 'package:collection/collection.dart';

enum CurrencyType {
  usD(1),
  vnD(2);
  
  static CurrencyType fromValue (int value){
    return  CurrencyType.values.firstWhereOrNull((e) => e.value==value)??CurrencyType.usD;
  }
  final int value;
  const CurrencyType(this.value);
}

extension ConvertTypeAccount on CurrencyType {
  String toText() {
    switch (this) {
      case CurrencyType.usD:
        return 'USD';
      case CurrencyType.vnD:
        return 'VND';
    }
  }
}
