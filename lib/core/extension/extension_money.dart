import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

extension NumExtensions on num {
  String toMoneyStrContext(
    BuildContext context, {
    bool isPrefix = false,
    bool showSymbol = true,
    bool compact = true,
  }) {
    final ref = ProviderScope.containerOf(context);
    final currentCurrency =
        ref.read(userBaseControllerProvider.select((value) => value.currency));

    return _toMoney(
      currency: currentCurrency,
      isPrefix: isPrefix,
      showSymbol: showSymbol,
      compact: compact,
    );
  }

  String toMoneyStr(
    WidgetRef ref, {
    bool isPrefix = false,
    bool showSymbol = true,
    bool compact = true,
  }) {
    final currentCurrency =
        ref.watch(userBaseControllerProvider.select((value) => value.currency));

    return _toMoney(
      currency: currentCurrency,
      isPrefix: isPrefix,
      showSymbol: showSymbol,
      compact: compact,
    );
  }

  String _toMoney({
    required CurrencyType currency,
    required bool isPrefix,
    required bool showSymbol,
    required bool compact,
  }) {
    if (compact) {
      return _toMoneyStrTruncated(currency: currency, isPrefix: isPrefix);
    }

    String formattedNumber;
    NumberFormat formatter;

    // Create formatter based on currency type
    switch (currency) {
      case CurrencyType.vnd:
        formatter = NumberFormat.currency(
          locale: currency.locale,
          symbol: showSymbol ? 'VNĐ' : '',
          decimalDigits: 0,
        );
        break;
      case CurrencyType.usd:
        formatter = NumberFormat.currency(
          locale: currency.locale,
          symbol: showSymbol ? '\$' : '',
          decimalDigits: 2,
        );
        break;
      case CurrencyType.eur:
        formatter = NumberFormat.currency(
          locale: 'de_DE', // Better Euro formatting
          symbol: showSymbol ? '€' : '',
          decimalDigits: 2,
        );
        break;
      case CurrencyType.jpy:
        formatter = NumberFormat.currency(
          locale: currency.locale,
          symbol: showSymbol ? '¥' : '',
          decimalDigits: 0,
        );
        break;
      case CurrencyType.cad:
        formatter = NumberFormat.currency(
          locale: currency.locale,
          symbol: showSymbol ? 'C\$' : '',
          decimalDigits: 2,
        );
        break;
    }

    formattedNumber = formatter.format(this);

    if (!isPrefix || this == 0) {
      return formattedNumber;
    }
    return this > 0 ? '+$formattedNumber' : formattedNumber;
  }

  String _toMoneyStrTruncated({
    required CurrencyType currency,
    bool isPrefix = false,
    int maxLength = 10,
  }) {
    // Handle large numbers with abbreviations
    double absValue = abs().toDouble();
    String abbreviatedValue;
    String suffix = '';

    if (absValue >= 1000000000) {
      abbreviatedValue = (this / 1000000000).toStringAsFixed(1);
      suffix = 'B';
    } else if (absValue >= 1000000) {
      abbreviatedValue = (this / 1000000).toStringAsFixed(1);
      suffix = 'M';
    } else if (absValue >= 1000) {
      abbreviatedValue = (this / 1000).toStringAsFixed(1);
      suffix = 'K';
    } else {
      String regular = _toMoney(
          currency: currency,
          isPrefix: false,
          compact: false,
          showSymbol: false);
      if (regular.length <= maxLength) {
        return isPrefix && this > 0 ? '+$regular' : regular;
      }
      abbreviatedValue = currency.hasDecimals
          ? toStringAsFixed(currency.decimalPlaces)
          : toStringAsFixed(0);
    }

    // Remove trailing .0 for cleaner display
    if (abbreviatedValue.endsWith('.0')) {
      abbreviatedValue =
          abbreviatedValue.substring(0, abbreviatedValue.length - 2);
    }

    // Apply currency symbol and format
    String result;
    switch (currency) {
      case CurrencyType.vnd:
        result = '$abbreviatedValue$suffix VNĐ';
        break;
      case CurrencyType.usd:
        result = '\$$abbreviatedValue$suffix';
        break;
      case CurrencyType.eur:
        result = '$abbreviatedValue$suffix €';
        break;
      case CurrencyType.jpy:
        result = '¥$abbreviatedValue$suffix';
        break;
      case CurrencyType.cad:
        result = 'C\$$abbreviatedValue$suffix';
        break;
    }

    // Apply prefix if needed
    if (isPrefix && this > 0) {
      result = '+$result';
    }

    return result;
  }

  /// Formats money with proper separators (no currency symbol)
  String toFormattedNumber({CurrencyType currencyType = CurrencyType.vnd}) {
    final formatter = NumberFormat.decimalPattern(currencyType.locale);
    return formatter.format(this);
  }

  /// Get currency symbol only
  String getCurrencySymbol(CurrencyType currencyType) {
    return currencyType.symbol;
  }

  /// Convert between currencies (placeholder - you'd need exchange rates)
  double convertCurrency({
    required CurrencyType from,
    required CurrencyType to,
    Map<String, double>? exchangeRates,
  }) {
    // This is a placeholder implementation
    // In a real app, you'd fetch live exchange rates
    if (from == to) return toDouble();

    // Default rates (these should come from an API)
    final defaultRates = {
      'USD_EUR': 0.85,
      'USD_JPY': 110.0,
      'USD_VND': 23000.0,
      'USD_CAD': 1.25,
      'EUR_USD': 1.18,
      'JPY_USD': 0.009,
      'VND_USD': 0.000043,
      'CAD_USD': 0.80,
    };

    final rateKey = '${from.code}_${to.code}';
    final rate = exchangeRates?[rateKey] ?? defaultRates[rateKey] ?? 1.0;

    return toDouble() * rate;
  }
}
