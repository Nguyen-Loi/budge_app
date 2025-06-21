import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budget_app/core/enums/currency_type_enum.dart';

class CurrencyExchangeService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';

  // Cache for exchange rates
  static final Map<String, Map<String, double>> _rateCache = {};
  static DateTime? _lastUpdate;
  static const Duration _cacheExpiration = Duration(hours: 1);

  /// Fetch live exchange rates from API
  static Future<Map<String, double>> fetchExchangeRates(
      String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = Map<String, double>.from(data['rates']);

        // Cache the rates
        _rateCache[baseCurrency] = rates;
        _lastUpdate = DateTime.now();

        return rates;
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      // Fallback to cached rates or default rates
      return _getFallbackRates(baseCurrency);
    }
  }

  /// Get cached exchange rates or fetch new ones if expired
  static Future<Map<String, double>> getExchangeRates(
      String baseCurrency) async {
    final now = DateTime.now();
    final hasValidCache = _rateCache.containsKey(baseCurrency) &&
        _lastUpdate != null &&
        now.difference(_lastUpdate!) < _cacheExpiration;

    if (hasValidCache) {
      return _rateCache[baseCurrency]!;
    } else {
      return await fetchExchangeRates(baseCurrency);
    }
  }

  /// Convert amount between currencies
  static Future<double> convertCurrency({
    required double amount,
    required CurrencyType from,
    required CurrencyType to,
  }) async {
    if (from == to) return amount;

    try {
      final rates = await getExchangeRates(from.code);
      final toRate = rates[to.code];

      if (toRate != null) {
        return amount * toRate;
      } else {
        throw Exception('Exchange rate not found for ${to.code}');
      }
    } catch (e) {
      // Fallback to default conversion
      return _fallbackConversion(amount, from, to);
    }
  }

  /// Get fallback rates when API is unavailable
  static Map<String, double> _getFallbackRates(String baseCurrency) {
    // Default rates relative to USD
    final usdRates = {
      'USD': 1.0,
      'EUR': 0.85,
      'JPY': 110.0,
      'VND': 23000.0,
      'CAD': 1.25,
    };

    if (baseCurrency == 'USD') {
      return usdRates;
    }

    // Convert rates to the requested base currency
    final baseRate = usdRates[baseCurrency] ?? 1.0;
    final convertedRates = <String, double>{};

    for (final entry in usdRates.entries) {
      convertedRates[entry.key] = entry.value / baseRate;
    }

    return convertedRates;
  }

  /// Fallback conversion using default rates
  static double _fallbackConversion(
      double amount, CurrencyType from, CurrencyType to) {
    final defaultRates = {
      '${CurrencyType.usd.code}_${CurrencyType.eur.code}': 0.85,
      '${CurrencyType.usd.code}_${CurrencyType.jpy.code}': 110.0,
      '${CurrencyType.usd.code}_${CurrencyType.vnd.code}': 23000.0,
      '${CurrencyType.usd.code}_${CurrencyType.cad.code}': 1.25,
      '${CurrencyType.eur.code}_${CurrencyType.usd.code}': 1.18,
      '${CurrencyType.jpy.code}_${CurrencyType.usd.code}': 0.009,
      '${CurrencyType.vnd.code}_${CurrencyType.usd.code}': 0.000043,
      '${CurrencyType.cad.code}_${CurrencyType.usd.code}': 0.80,
    };

    final key = '${from.code}_${to.code}';
    final rate = defaultRates[key] ?? 1.0;

    return amount * rate;
  }

  /// Get supported currency codes
  static List<String> getSupportedCurrencyCodes() {
    return CurrencyType.values.map((e) => e.code).toList();
  }

  /// Clear cache (useful for testing or manual refresh)
  static void clearCache() {
    _rateCache.clear();
    _lastUpdate = null;
  }
}
