import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:intl/intl.dart';

extension NumExtensions on num {
  String toMoneyStr(
      {CurrencyType currencyType = CurrencyType.vnd, bool isPrefix = false}) {
    String formattedNumber;
    switch (currencyType) {
      case CurrencyType.vnd:
        var formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
        formattedNumber = formatter.format(this);
        break;
      case CurrencyType.usd:
        var formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
        formattedNumber = formatter.format(this);
        break;
    }

    if (!isPrefix || this == 0) {
      return formattedNumber;
    }
    return this > 0 ? '+$formattedNumber' : '-$formattedNumber';
  }
}
