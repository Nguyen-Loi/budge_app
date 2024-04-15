class BDateTime {
  static int month(DateTime time) {
    final month = DateTime(time.year, time.month).millisecondsSinceEpoch;
    return month;
  }
}
