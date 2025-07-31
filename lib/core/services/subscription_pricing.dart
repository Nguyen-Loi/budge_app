import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';

class SubscriptionPricing {
  // Pricing based on location
  // Vietnam: 10,000 VND monthly, 100,000 VND yearly
  // All other locations: $1 USD monthly, $10 USD yearly

  static const Map<String, double> _monthlyPrices = {
    'VND': 10000.0, 
  };

  static const Map<String, double> _yearlyPrices = {
    'VND': 100000.0, 
  };

  // App Store/Google Play product IDs
  static const Map<String, String> _productIds = {
    'monthly_vnd': 'budget_premium_monthly_vnd',
    'yearly_vnd': 'budget_premium_yearly_vnd',
    'monthly_usd': 'budget_premium_monthly_usd',
    'yearly_usd': 'budget_premium_yearly_usd',
  };

  /// Get the monthly price in the user's currency
  static double getMonthlyPrice(CurrencyType currency) {
    if (currency.code == 'VND') {
      return _monthlyPrices['VND']!;
    } else {
      return 1.0;
    }
  }

  /// Get the yearly price in the user's currency
  static double getYearlyPrice(CurrencyType currency) {
    if (currency.code == 'VND') {
      return _yearlyPrices['VND']!;
    } else {
      return 10.0;
    }
  }

  /// Get the monthly equivalent of yearly price
  static double getYearlyMonthlyEquivalent(CurrencyType currency) {
    return getYearlyPrice(currency) / 12;
  }

  static double getYearlySavingsPercentage(CurrencyType currency) {
    final monthlyPrice = getMonthlyPrice(currency);
    final yearlyMonthlyEquivalent = getYearlyMonthlyEquivalent(currency);

    if (monthlyPrice == 0) return 0;

    final savings = (monthlyPrice - yearlyMonthlyEquivalent) / monthlyPrice;
    return (savings * 100).roundToDouble();
  }

  /// Get product ID for the given plan and currency
  static String getProductId(SubscriptionPlanEnum plan, CurrencyType currency) {
    final key = '${plan.name}_${currency.code.toLowerCase()}';
    return _productIds[key] ?? _productIds['${plan.name}_usd']!;
  }

  /// Get all available product IDs for a currency
  static List<String> getProductIdsForCurrency(CurrencyType currency) {
    return [
      getProductId(SubscriptionPlanEnum.monthly, currency),
      getProductId(SubscriptionPlanEnum.yearly, currency),
    ];
  }

  /// Format price for display
  static String formatPrice(double price, CurrencyType currency) {
    if (currency.hasDecimals) {
      return '${currency.symbol}${price.toStringAsFixed(2)}';
    } else {
      return '${currency.symbol}${price.toStringAsFixed(0)}';
    }
  }

  /// Get formatted monthly price
  static String getFormattedMonthlyPrice(CurrencyType currency) {
    return formatPrice(getMonthlyPrice(currency), currency);
  }

  /// Get formatted yearly price
  static String getFormattedYearlyPrice(CurrencyType currency) {
    return formatPrice(getYearlyPrice(currency), currency);
  }

  /// Get formatted yearly monthly equivalent
  static String getFormattedYearlyMonthlyEquivalent(CurrencyType currency) {
    return formatPrice(getYearlyMonthlyEquivalent(currency), currency);
  }

  /// Validate if a price matches expected pricing
  static bool validatePrice(double price, String plan, CurrencyType currency) {
    final expectedPrice = plan == 'monthly'
        ? getMonthlyPrice(currency)
        : getYearlyPrice(currency);

    // Allow for small variations due to app store pricing tiers
    final tolerance = expectedPrice * 0.1; // 10% tolerance
    return (price - expectedPrice).abs() <= tolerance;
  }
}
