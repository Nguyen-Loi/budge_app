extension FilterIterable<T> on Iterable<T> {
  Iterable<T> filterByMonth(
      {required DateTime time, required DateTime Function(T) getDate}) {
    DateTime startDate = DateTime(time.year, time.month, 1);
    DateTime endDate = DateTime(time.year, time.month + 1);
    return where((item) {
      DateTime itemDate = getDate(item);
      return itemDate.isAfter(startDate) && itemDate.isBefore(endDate);
    });
  }

  Iterable<T> filterByWeek(
      {required DateTime time, required DateTime Function(T) getDate}) {
    DateTime startDate = time.subtract(Duration(days: time.weekday - 1));
    DateTime endDate = startDate.add(const Duration(days: 7));
    return where((item) {
      DateTime itemDate = getDate(item);
      return itemDate.isAfter(startDate) && itemDate.isBefore(endDate);
    });
  }
}
