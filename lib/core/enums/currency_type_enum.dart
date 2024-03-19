

enum CurrencyType {
  vnd(1),
  usd(2);
  
  static CurrencyType fromValue (int value){
    return  CurrencyType.values.firstWhere((e) => e.value==value);
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
