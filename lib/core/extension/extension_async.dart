Future<Iterable<T>> waitOn<T>(
  Iterable<Future<T>> futures,
  Function onError,
) async {
  List<T> result = [];
  for (final future in futures) {
    final value = await future.catchError(onError);
    result.add(value);
  }
  return result;
}

Future<F> retry<F>(Future<F> Function() future,
    {int maxCount = 5, Duration delay = Duration.zero}) async {
  try {
    return await future();
  } catch (e) {
    if (maxCount > 1) {
      return Future.delayed(delay)
          .then((value) => retry(future, maxCount: maxCount - 1, delay: delay));
    } else {
      rethrow;
    }
  }
}
