import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:intl/intl.dart';

/// Enhanced currency utility class for improved amount handling
class CurrencyUtils {
  static const int _maxSafeInteger = 9223372036854775807; // Max int64
  static const int _maxSafeDecimalAmount =
      922337203685477; // Max safe for 2-decimal currencies

  /// Convert display amount to storage amount (minor units)
  /// Example: $12.34 → 1234 cents, ¥500 → 500 yen
  static int toStorageAmount(double displayAmount, CurrencyType currency) {
    if (currency.hasDecimals) {
      final result = (displayAmount * 100).round();
      if (result > _maxSafeDecimalAmount) {
        throw ArgumentError('Amount too large: $displayAmount');
      }
      return result;
    }

    final result = displayAmount.round();
    if (result > _maxSafeInteger) {
      throw ArgumentError('Amount too large: $displayAmount');
    }
    return result;
  }

  /// Convert storage amount to display amount
  /// Example: 1234 cents → $12.34, 500 yen → ¥500
  static double toDisplayAmount(int storageAmount, CurrencyType currency) {
    if (currency.hasDecimals) {
      return storageAmount / 100.0;
    }
    return storageAmount.toDouble();
  }

  /// Validate amount input for storage
  static bool isValidAmount(int? amount, CurrencyType currency) {
    if (amount == null || amount <= 0) return false;

    final maxAmount =
        currency.hasDecimals ? _maxSafeDecimalAmount : _maxSafeInteger;
    return amount <= maxAmount;
  }

  /// Get the maximum safe amount for a currency
  static int getMaxSafeAmount(CurrencyType currency) {
    return currency.hasDecimals ? _maxSafeDecimalAmount : _maxSafeInteger;
  }

  /// Get the minimum amount (smallest unit) for a currency
  static int getMinAmount(CurrencyType currency) {
    return 1; // 1 cent or 1 unit
  }

  /// Format amount for exact financial display (always shows full precision)
  static String formatExact(int storageAmount, CurrencyType currency) {
    final displayAmount = toDisplayAmount(storageAmount, currency);

    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: currency.decimalPlaces,
    );

    return formatter.format(displayAmount);
  }

  /// Format amount for compact display with K/M/B suffixes
  static String formatCompact(int storageAmount, CurrencyType currency) {
    final displayAmount = toDisplayAmount(storageAmount, currency);

    String value;
    String suffix = '';

    final absAmount = displayAmount.abs();
    if (absAmount >= 1000000000) {
      value = (displayAmount / 1000000000).toStringAsFixed(1);
      suffix = 'B';
    } else if (absAmount >= 1000000) {
      value = (displayAmount / 1000000).toStringAsFixed(1);
      suffix = 'M';
    } else if (absAmount >= 1000) {
      value = (displayAmount / 1000).toStringAsFixed(1);
      suffix = 'K';
    } else {
      return formatExact(storageAmount, currency);
    }

    // Remove trailing .0
    if (value.endsWith('.0')) {
      value = value.substring(0, value.length - 2);
    }

    return '${currency.symbol}$value$suffix';
  }

  /// Convert amount between currencies with exchange rate
  static int convertCurrency({
    required int amount,
    required CurrencyType fromCurrency,
    required CurrencyType toCurrency,
    required double exchangeRate,
  }) {
    if (fromCurrency == toCurrency) return amount;

    // Convert to display amount
    final fromDisplayAmount = toDisplayAmount(amount, fromCurrency);

    // Apply exchange rate
    final convertedDisplayAmount = fromDisplayAmount * exchangeRate;

    // Convert to target currency storage format
    return toStorageAmount(convertedDisplayAmount, toCurrency);
  }

  /// Parse string input to storage amount
  static int? parseInput(String input, CurrencyType currency) {
    if (input.isEmpty) return null;

    // Clean input: remove currency symbols, commas, and extra spaces
    String cleanInput = input
        .replaceAll(currency.symbol, '')
        .replaceAll(',', '') // Remove thousand separators
        .replaceAll(' ', '')
        .trim();

    // Handle empty input after cleaning
    if (cleanInput.isEmpty) return null;

    // Try to parse as double
    final displayAmount = double.tryParse(cleanInput);
    if (displayAmount == null) return null;

    // Check for negative values
    if (displayAmount < 0) return null;

    try {
      return toStorageAmount(displayAmount, currency);
    } catch (e) {
      return null; // Amount too large
    }
  }

  /// Format amount with prefix for transactions (+/-)
  static String formatWithPrefix(
    int storageAmount,
    CurrencyType currency, {
    bool showPositivePrefix = true,
  }) {
    final formatted = formatExact(storageAmount.abs(), currency);

    if (storageAmount > 0 && showPositivePrefix) {
      return '+$formatted';
    } else if (storageAmount < 0) {
      return '-$formatted';
    }

    return formatted;
  }

  static String getCurrencyDisplayName(CurrencyType currency, String locale) {
    // This could be enhanced with proper i18n
    switch (currency) {
      case CurrencyType.usd:
        return locale.startsWith('vi') ? 'Đô la Mỹ' : 'US Dollar';
      case CurrencyType.eur:
        return locale.startsWith('vi') ? 'Euro' : 'Euro';
      case CurrencyType.jpy:
        return locale.startsWith('vi') ? 'Yên Nhật' : 'Japanese Yen';
      case CurrencyType.vnd:
        return locale.startsWith('vi') ? 'Đồng Việt Nam' : 'Vietnamese Dong';
      case CurrencyType.cad:
        return locale.startsWith('vi') ? 'Đô la Canada' : 'Canadian Dollar';
    }
  }

  /// Validate that amount fits within safe integer bounds
  static String? validateAmount(int? amount, CurrencyType currency) {
    if (amount == null) return 'Amount is required';
    if (amount <= 0) return 'Amount must be greater than zero';

    final maxAmount = getMaxSafeAmount(currency);
    if (amount > maxAmount) {
      return 'Amount too large. Maximum: ${formatExact(maxAmount, currency)}';
    }

    return null; // Valid
  }

  /// Round amount to currency precision
  static int roundToCurrencyPrecision(double amount, CurrencyType currency) {
    if (currency.hasDecimals) {
      // Round to nearest cent
      return (amount * 100).round();
    }
    // Round to nearest whole unit
    return amount.round();
  }

  /// Calculate percentage of amount
  static int calculatePercentage(int baseAmount, double percentage) {
    final displayAmount = baseAmount * (percentage / 100.0);
    return displayAmount.round();
  }

  /// Add two amounts with overflow protection
  static int addAmounts(int amount1, int amount2, CurrencyType currency) {
    final maxAmount = getMaxSafeAmount(currency);

    // Check for overflow
    if (amount1 > maxAmount - amount2) {
      throw ArgumentError('Addition would cause overflow');
    }

    return amount1 + amount2;
  }

  /// Subtract two amounts
  static int subtractAmounts(int amount1, int amount2) {
    return amount1 - amount2;
  }

  /// Get suggested input format hint for currency
  static String getInputHint(CurrencyType currency) {
    if (currency.hasDecimals) {
      return currency == CurrencyType.usd ? '1,000.00' : '1,000.00';
    }
    return currency == CurrencyType.vnd ? '1,000,000' : '1,000';
  }

  /// Check if two amounts are equal considering currency precision
  static bool areAmountsEqual(int amount1, int amount2) {
    return amount1 == amount2;
  }

  /// Format amount for CSV/Excel export
  static String formatForExport(int storageAmount, CurrencyType currency) {
    final displayAmount = toDisplayAmount(storageAmount, currency);
    return displayAmount.toStringAsFixed(currency.decimalPlaces);
  }
}

extension CurrencyAmountExtension on int {
  double toDisplayAmount(CurrencyType currency) {
    return CurrencyUtils.toDisplayAmount(this, currency);
  }

  String formatCurrency(CurrencyType currency) {
    return CurrencyUtils.formatExact(this, currency);
  }

  String formatCompact(CurrencyType currency) {
    return CurrencyUtils.formatCompact(this, currency);
  }

  String formatWithPrefix(CurrencyType currency,
      {bool showPositivePrefix = true}) {
    return CurrencyUtils.formatWithPrefix(this, currency,
        showPositivePrefix: showPositivePrefix);
  }

  String? validateAmount(CurrencyType currency) {
    return CurrencyUtils.validateAmount(this, currency);
  }

  int convertTo(
      CurrencyType fromCurrency, CurrencyType toCurrency, double exchangeRate) {
    return CurrencyUtils.convertCurrency(
      amount: this,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      exchangeRate: exchangeRate,
    );
  }
}

extension CurrencyDisplayExtension on double {
  int toStorageAmount(CurrencyType currency) {
    return CurrencyUtils.toStorageAmount(this, currency);
  }
}
