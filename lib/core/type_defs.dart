
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


extension EitherHelpers<L, R> on Either<L, R> {
  R? unwrapRight() {
    return toOption().toNullable();
  }
}

extension FutureEitherHelpers<T> on Either<Failure, T> {
  Failure getLeftOrDefault({String? defaultError}) {
    final result = this;
    return result.fold(
      (l) => l,
      (r) => Failure(error: defaultError),
    );

  }
}