import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:intl/intl.dart';

extension NumExtensions on num {
  String toMoneyStr({CurrencyType currencyType = CurrencyType.vnd}) {
    switch (currencyType) {
      case CurrencyType.vnd:
        return _formatVND(this);
      case CurrencyType.usd:
        NumberFormat numberFormat =
            NumberFormat.currency(locale: 'en_US', symbol: '\$');
        return numberFormat.format(this);
    }
  }
  
  /// Increase to 1000 with currency vnd
  int toAmountMoney({CurrencyType currencyType = CurrencyType.vnd}) {
    switch (currencyType) {
      case CurrencyType.vnd:
        return round() * 1000;
      case CurrencyType.usd:
        return round();
    }
  }
}

String _formatVND(num value) {
  if (value >= 1000000000) {
    double formattedValue = value / 1000000000;
    return '${formattedValue.toStringAsFixed(2)} ß';
  } else if (value >= 1000000) {
    double formattedValue = value / 1000000;
    return '${formattedValue.toStringAsFixed(2)} ʍ';
  } else {
    final formatCurrency = NumberFormat("#,##0");
    return '${formatCurrency.format(value.toInt())} đ';
  }
}
