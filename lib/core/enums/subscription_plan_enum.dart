import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum SubscriptionPlanEnum {
  monthlyPremium('monthly_premium', 30),
  yearlyPremium('yearly_premium', 365);

  factory SubscriptionPlanEnum.fromProductId(String productId) {
    return SubscriptionPlanEnum.values.firstWhere(
      (e) => e.productId == productId,
      orElse: () => throw Exception('Invalid product ID: $productId'),
    );
  }

  final String productId;
  final int durationDays;
  const SubscriptionPlanEnum(
      this.productId, this.durationDays);
}

extension SubscriptionProductEnumX on SubscriptionPlanEnum {

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