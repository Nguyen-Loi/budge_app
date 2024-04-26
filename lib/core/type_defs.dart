import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/main.dart';
import 'package:fpdart/fpdart.dart';

class Failure {
  String? _error;
  String? _message;
  Failure({String? error, String? message}) {
    _error = error!;
    _message = message!;
  }

  String get error =>
      _error ?? navigatorKey.currentContext!.loc.anErrorUnexpectedOccur;
  String get message =>
      _message ?? navigatorKey.currentContext!.loc.anErrorUnexpectedOccur;
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
