

enum CurrencyType {
  vnd(1),
  usd(2);
  
  factory CurrencyType.fromValue (int value){
    return  CurrencyType.values.firstWhere((e) => e.value==value);
  }
  final int value;
  const CurrencyType(this.value);
}

extension ConvertTypeAccount on CurrencyType {
  String toSymbol() {
    switch (this) {
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.vnd:
        return 'VND';
    }
  }
}
