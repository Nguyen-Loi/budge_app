import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  final String error;
  const Failure(
      {this.error = 'Error', this.message = 'An error unexpected occur!'});
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
