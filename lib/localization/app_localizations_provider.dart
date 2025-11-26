import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:flutter_riverpod/legacy.dart';

final languageControllerProvider = StateProvider<Locale>((ref) {
  return WidgetsBinding.instance.platformDispatcher.locale;
});

// Provider for the AppLocalizations for the current locale
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(languageControllerProvider);
  return lookupAppLocalizations(locale);
});

/// observed used to notify the caller when the locale changes
class LocaleObserver extends WidgetsBindingObserver {
  final void Function(Locale) onLocaleChanged;
  LocaleObserver(this.onLocaleChanged);

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      onLocaleChanged(locales.first);
    }
  }
}
