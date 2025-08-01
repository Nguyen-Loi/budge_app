import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/utils/data_config_utils.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

enum SubscriptionPlanEnum {
  monthlyVnd('monthly_vnd', 10000, 30, CurrencyType.vnd),
  yearlyVnd('yearly_vnd', 100000, 365, CurrencyType.vnd),
  monthlyUsd('monthly_usd', 10, 30, CurrencyType.usd),
  yearlyUsd('yearly_usd', 100, 365, CurrencyType.usd);

  static List<SubscriptionPlanEnum> get listInAppPurchase =>
      SubscriptionPlanEnum.values
          .where((e) => e.currencyType == DataConfigUtils.instance.currencyType)
          .toList();

  static SubscriptionPlanEnum get defaultPlan {
    return listInAppPurchase.firstWhere(
      (e) => e.name.contains('monthly'),
    );
  }

  bool get isYearly =>
      this == SubscriptionPlanEnum.yearlyVnd ||
      this == SubscriptionPlanEnum.yearlyUsd;

  bool get isMonthly =>
      this == SubscriptionPlanEnum.monthlyVnd ||
      this == SubscriptionPlanEnum.monthlyUsd;

  factory SubscriptionPlanEnum.fromProductId(String productId) {
    return SubscriptionPlanEnum.values.firstWhere(
      (e) => e.productId == productId,
      orElse: () => throw Exception('Invalid product ID: $productId'),
    );
  }

  final String productId;
  final int price;
  final int durationDays;
  final CurrencyType currencyType;
  const SubscriptionPlanEnum(
      this.productId, this.price, this.durationDays, this.currencyType);
}

extension SubscriptionProductEnumX on SubscriptionPlanEnum {
  String get displayPrice {
    return "${currencyType.symbol}${price.toStringAsFixed(currencyType.decimalPlaces)}";
  }

  String content(BuildContext context) {
    AppLocalizations loc = context.loc;
    if (isYearly) {
      return loc.yearly;
    }
    if (isMonthly) {
      return loc.monthly;
    }
    throw Exception("Invalid subscription plan: $this");
  }
}
