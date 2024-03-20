import 'package:intl/intl.dart';

extension NumExtensions on num {
  String toMoneyStr({String currency = 'USD'}) {
    // Define the format for USD and VND
    final usdFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final vndFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    final format = currency.toUpperCase() == 'VND' ? vndFormat : usdFormat;

    return format.format(this);
  }
}
