enum CurrencyType {
  vnd(1, 'vi'),
  usd(2, 'en');

  factory CurrencyType.fromValue(int value) {
    return CurrencyType.values.firstWhere((e) => e.value == value);
  }
  final int value;
  final String code;
  const CurrencyType(this.value, this.code);
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
