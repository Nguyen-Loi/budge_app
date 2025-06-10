import 'package:flutter/widgets.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
