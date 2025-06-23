import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:intl/intl.dart';

class CurrencyManager {
  static final CurrencyManager _instance = CurrencyManager._internal();
  factory CurrencyManager() => _instance;
  CurrencyManager._internal();

  /// Get currency formatter for input fields
  NumberFormat getCurrencyFormatter(CurrencyType currency) {
    switch (currency) {
      case CurrencyType.vnd:
        return NumberFormat.decimalPattern('vi_VN');
      case CurrencyType.usd:
        return NumberFormat.decimalPattern('en_US');
      case CurrencyType.eur:
        return NumberFormat.decimalPattern('de_DE');
      case CurrencyType.jpy:
        return NumberFormat.decimalPattern('ja_JP');
      case CurrencyType.cad:
        return NumberFormat.decimalPattern('en_CA');
    }
  }

  /// Get currency symbol for display
  String getCurrencySymbol(CurrencyType currency) {
    return currency.symbol;
  }

  /// Get compact currency symbol for space-constrained displays
  String getCompactSymbol(CurrencyType currency) {
    switch (currency) {
      case CurrencyType.vnd:
        return 'đ';
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.eur:
        return '€';
      case CurrencyType.jpy:
        return '¥';
      case CurrencyType.cad:
        return 'C\$';
    }
  }

  /// Validate amount input for currency
  bool isValidAmount(String input, CurrencyType currency) {
    if (input.isEmpty) return false;

    // Remove currency symbols and whitespace
    String cleanInput =
        input.replaceAll(RegExp(r'[^\d.,\-]'), '').replaceAll(',', '');

    // Try to parse as number
    final parsed = double.tryParse(cleanInput);
    if (parsed == null) return false;

    // Check decimal places
    if (cleanInput.contains('.')) {
      final decimalPart = cleanInput.split('.').last;
      if (decimalPart.length > currency.decimalPlaces) {
        return false;
      }
    }

    return true;
  }

  /// Parse amount string to number
  double? parseAmount(String input, CurrencyType currency) {
    if (!isValidAmount(input, currency)) return null;

    String cleanInput =
        input.replaceAll(RegExp(r'[^\d.,\-]'), '').replaceAll(',', '');

    return double.tryParse(cleanInput);
  }

  /// Format input as user types
  String formatInputAsTyping(String input, CurrencyType currency) {
    final amount = parseAmount(input, currency);
    if (amount == null) return input;

    final formatter = getCurrencyFormatter(currency);
    return formatter.format(amount);
  }

  /// Get all supported currencies
  List<CurrencyType> getSupportedCurrencies() {
    return CurrencyType.values;
  }

  /// Get currency by country code
  CurrencyType? getCurrencyByCountry(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'US':
        return CurrencyType.usd;
      case 'VN':
        return CurrencyType.vnd;
      case 'JP':
        return CurrencyType.jpy;
      case 'CA':
        return CurrencyType.cad;
      case 'DE':
      case 'FR':
      case 'IT':
      case 'ES':
      case 'AT':
      case 'BE':
      case 'NL':
        return CurrencyType.eur;
      default:
        return null;
    }
  }

  /// Get exchange rate placeholder (should be replaced with real API)
  double getExchangeRate(CurrencyType from, CurrencyType to) {
    if (from == to) return 1.0;

    // Placeholder rates - replace with real exchange rate API
    final rates = {
      '${CurrencyType.usd.code}_${CurrencyType.eur.code}': 0.85,
      '${CurrencyType.usd.code}_${CurrencyType.jpy.code}': 110.0,
      '${CurrencyType.usd.code}_${CurrencyType.vnd.code}': 23000.0,
      '${CurrencyType.usd.code}_${CurrencyType.cad.code}': 1.25,
      // Add reverse rates
      '${CurrencyType.eur.code}_${CurrencyType.usd.code}': 1.18,
      '${CurrencyType.jpy.code}_${CurrencyType.usd.code}': 0.009,
      '${CurrencyType.vnd.code}_${CurrencyType.usd.code}': 0.000043,
      '${CurrencyType.cad.code}_${CurrencyType.usd.code}': 0.80,
    };

    final key = '${from.code}_${to.code}';
    return rates[key] ?? 1.0;
  }

  /// Convert amount between currencies
  double convertAmount(double amount, CurrencyType from, CurrencyType to) {
    final rate = getExchangeRate(from, to);
    return amount * rate;
  }
}

final currencyManagerProvider = Provider<CurrencyManager>((ref) {
  return CurrencyManager();
});