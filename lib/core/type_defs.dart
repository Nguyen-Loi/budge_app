
import 'package:fpdart/fpdart.dart';

class Failure {
  String? _error;
  String? _message;
  Failure({String? error, String? message}) {
    _error = error;
    _message = message;
  }

  String get error =>
      _error ?? 'An error unexpected occur';
  String get message =>
      _message ?? 'An error unexpected occur';
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
