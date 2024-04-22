import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:fpdart/fpdart.dart';

class Failure {
  String? _error;
  String? _message;
  Failure({String? error, String? message}) {
    _error = error!;
    _message = message!;
  }

  String get error => _error ?? 'anErrorUnexpectedOccur'.hardcoded;
  String get message => _message ?? 'anErrorUnexpectedOccur'.hardcoded;
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
