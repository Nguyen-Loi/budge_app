extension Group<T> on Iterable<T> {
  // Group data by name
  Map<K, Iterable<T>> groupBy<K>(K Function(T) key) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final keyValue = key(element);
      if (!map.containsKey(keyValue)) {
        map[keyValue] = [];
      }
      map[keyValue]?.add(element);
    }
    return map;
  }
}
