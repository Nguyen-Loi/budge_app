import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/services/subscription_pricing.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/widgets.dart';

enum SubscriptionPlanEnum {
  monthly(30),
  yearly(365);

  factory SubscriptionPlanEnum.baseOnProductId(String productId) {
    return SubscriptionPlanEnum.values.firstWhere(
      (e) => productId.contains(e.name),
      orElse: () => SubscriptionPlanEnum.monthly,
    );
  }

  final int value;
  const SubscriptionPlanEnum(this.value);
}

extension SubscriptionPlanEnumX on SubscriptionPlanEnum {
  double amountDependsOnCurrency(CurrencyType currency) {
    switch (this) {
      case SubscriptionPlanEnum.monthly:
        return SubscriptionPricing.getMonthlyPrice(currency);
      case SubscriptionPlanEnum.yearly:
        return SubscriptionPricing.getYearlyPrice(currency);
    }
  }

  String content(BuildContext context) {
    AppLocalizations loc = context.loc;
    switch (this) {
      case SubscriptionPlanEnum.monthly:
        return loc.monthly;
      case SubscriptionPlanEnum.yearly:
        return loc.yearly;
    }
  }

  String displayPrice(BuildContext context) {
    double price = 0;
    switch (this) {
      case SubscriptionPlanEnum.monthly:
        price = SubscriptionPricing.getMonthlyPrice(CurrencyType.usd);
        break;
      case SubscriptionPlanEnum.yearly:
        price =
            SubscriptionPricing.getYearlyMonthlyEquivalent(CurrencyType.usd);
        break;
    }
    return "\$${price.toStringAsFixed(2)}";
  }
}
