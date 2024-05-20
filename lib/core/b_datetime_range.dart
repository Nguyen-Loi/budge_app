import 'package:flutter/material.dart';

class BDateTimeRange {
  static DateTimeRange week(DateTime time) {
    int currentWeekday = time.weekday;
    DateTime firstDayOfWeek = time.subtract(Duration(days: currentWeekday - 1));
    DateTime lastDayOfWeek = time.add(Duration(days: 7 - currentWeekday));
    return DateTimeRange(start: firstDayOfWeek, end: lastDayOfWeek);
  }

  static DateTimeRange month(DateTime time) {
    DateTime firstDayOfMonth = DateTime(time.year, time.month, 1);
    DateTime lastDayOfMonth = DateTime(time.year, time.month + 1, 0);
    return DateTimeRange(start: firstDayOfMonth, end: lastDayOfMonth);
  }

  static DateTimeRange year(DateTime time) {
    DateTime firstDayOfYear = DateTime(time.year, 1, 1);
    DateTime lastDayOfYear = DateTime(time.year, 12, 31);
    return DateTimeRange(start: firstDayOfYear, end: lastDayOfYear);
  }
}
