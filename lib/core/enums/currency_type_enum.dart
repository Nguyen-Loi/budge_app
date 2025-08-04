import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum CurrencyType {
  vnd('VND', 'đ', 'vi_VN', 0),
  usd('USD', '\$', 'en_US', 2),
  eur('EUR', '€', 'en_EU', 2),
  jpy('JPY', '¥', 'ja_JP', 0),
  cad('CAD', 'C\$', 'en_CA', 2);

  factory CurrencyType.fromValue(String value) {
    return CurrencyType.values.firstWhere(
      (e) => e.code == value.toUpperCase(),
      orElse: () => CurrencyType.usd,
    );
  }

  factory CurrencyType.fromLocale(Locale locale) {
    return CurrencyType.values.firstWhere(
      (e) => e.locale == locale.toString(),
      orElse: () => CurrencyType.usd,
    );
  }

  factory CurrencyType.fromLanguage(LanguageEnum language) {
    switch (language) {
      case LanguageEnum.vietnamese:
        return CurrencyType.vnd;
      default:
        return CurrencyType.usd; 
    }
  }

  const CurrencyType(
    this.code,
    this.symbol,
    this.locale,
    this.decimalPlaces,
  );

  final String code;
  final String symbol;
  final String locale;
  final int decimalPlaces;
}

extension ConvertTypeAccount on CurrencyType {
  String toSymbol() {
    return code;
  }

  String getDisplaySymbol() {
    return symbol;
  }

  String getDisplayName(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    switch (this) {
      case CurrencyType.usd:
        return localizations.usdCurrencyName;
      case CurrencyType.eur:
        return localizations.eurCurrencyName;
      case CurrencyType.jpy:
        return localizations.jpyCurrencyName;
      case CurrencyType.vnd:
        return localizations.vndCurrencyName;
      case CurrencyType.cad:
        return localizations.cadCurrencyName;
    }
  }

  bool get hasDecimals => decimalPlaces > 0;

  double getMinorUnits(double amount) {
    return amount * (decimalPlaces == 0 ? 1 : 100);
  }

  double getMajorUnits(double minorUnits) {
    return minorUnits / (decimalPlaces == 0 ? 1 : 100);
  }
}
