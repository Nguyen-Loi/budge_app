import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/utils/data_config_utils.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum SubscriptionPlanEnum {
  monthlyPremium('monthly_premium', 199, 30),
  yearlyPremium('yearly_premium', 1999, 365);

  factory SubscriptionPlanEnum.fromProductId(String productId) {
    return SubscriptionPlanEnum.values.firstWhere(
      (e) => e.productId == productId,
      orElse: () => throw Exception('Invalid product ID: $productId'),
    );
  }

  final String productId;
  final int price;
  final int durationDays;
  const SubscriptionPlanEnum(
      this.productId, this.price, this.durationDays);
}

extension SubscriptionProductEnumX on SubscriptionPlanEnum {
  String get displayPrice {
    CurrencyType currencyType = DataConfigUtils.instance.currencyType;
    if (currencyType == CurrencyType.vnd) {
      switch (this) {
        case SubscriptionPlanEnum.monthlyPremium:
          return "10,000đ";
        case SubscriptionPlanEnum.yearlyPremium:
          return "100,000đ";
      }
    }
    return "\$${price / 100}";
  }

  String content(BuildContext context) {
    AppLocalizations loc = context.loc;
    switch (this) {
      case SubscriptionPlanEnum.monthlyPremium:
        return loc.monthly;
      case SubscriptionPlanEnum.yearlyPremium:
        return loc.yearly;
    }
  }
}
