extension FilterIterable<T> on Iterable<T> {
  Iterable<T> filterByMonth({required DateTime time,required DateTime Function(T) getDate}) {
    DateTime startDate = DateTime(time.year, time.month, 1);
    DateTime endDate = DateTime(time.year, time.month + 1);
    return where((item) {
      DateTime itemDate = getDate(item);
      return itemDate.isAfter(startDate) && itemDate.isBefore(endDate);
    });
  }
}
