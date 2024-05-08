import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:intl/intl.dart';

extension NumExtensions on num {
  String toMoneyStr({CurrencyType currencyType = CurrencyType.vnd}) {
    switch (currencyType) {
      case CurrencyType.vnd:
        var formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
        return formatter.format(this);
      case CurrencyType.usd:
        NumberFormat numberFormat =
            NumberFormat.currency(locale: 'en_US', symbol: '\$');
        return numberFormat.format(this);
    }
  }
}
