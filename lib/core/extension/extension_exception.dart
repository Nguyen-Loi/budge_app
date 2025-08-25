import 'package:budget_app/common/exception/custom_exception.dart';
import 'package:budget_app/common/exception/network_exception.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';

extension ExceptionExtension on Object {
  String toErrorMessage(AppLocalizations loc) {
    bool canShowMessage = this is CustomException || this is NetworkException;
    if (canShowMessage) {
      String? message = (this as dynamic).message;
      return message != null
          ? loc.pAnErrorUnexpectedOccur(message)
          : loc.anErrorUnexpectedOccur;
    }
    return loc.anErrorUnexpectedOccur;
  }
}
