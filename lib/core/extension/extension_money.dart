import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:intl/intl.dart';

extension NumExtensions on num {
  String toMoneyStr(
      {CurrencyType currencyType = CurrencyType.vnd, bool isPrefix = false}) {
    String formattedNumber;
    switch (currencyType) {
      case CurrencyType.vnd:
        var formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
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
    return this > 0 ? '+$formattedNumber' : formattedNumber;
  }

  String toMoneyNoSymbolStr(
      {CurrencyType currencyType = CurrencyType.vnd, bool isPrefix = false}) {
    String formattedNumber;
    switch (currencyType) {
      case CurrencyType.vnd:
        var formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '');
        formattedNumber = formatter.format(this);
        break;
      case CurrencyType.usd:
        var formatter = NumberFormat.currency(locale: 'en_US', symbol: '');
        formattedNumber = formatter.format(this);
        break;
    }

    if (!isPrefix || this == 0) {
      return formattedNumber;
    }
    return this > 0 ? '+$formattedNumber' : formattedNumber;
  }

  String toMoneyStrTruncated(
      {CurrencyType currencyType = CurrencyType.vnd,
      bool isPrefix = false,
      int maxLength = 10}) {
    // Handle large numbers with abbreviations
    double absValue = abs().toDouble();
    String abbreviatedValue;

    if (absValue >= 1000000000) {
      abbreviatedValue = '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (absValue >= 1000000) {
      abbreviatedValue = '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (absValue >= 1000) {
      abbreviatedValue = '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      // For smaller numbers, use regular formatting but check length
      String regular = toMoneyStr(currencyType: currencyType, isPrefix: false);
      if (regular.length <= maxLength) {
        return isPrefix && this > 0 ? '+$regular' : regular;
      }
      abbreviatedValue = toStringAsFixed(0);
    }

    // Apply currency symbol
    String result;
    switch (currencyType) {
      case CurrencyType.vnd:
        result = '$abbreviatedValue VNĐ';
        break;
      case CurrencyType.usd:
        result = '\$$abbreviatedValue';
        break;
    }

    // Apply prefix if needed
    if (isPrefix && this > 0) {
      result = '+$result';
    }

    return result;
  }
}
