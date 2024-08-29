enum CurrencyType {
  vnd('VI', 'vi'),
  usd('EN', 'en');

  factory CurrencyType.fromValue(String value) {
    return CurrencyType.values.firstWhere((e) => e.value == value);
  }
  final String value;
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
