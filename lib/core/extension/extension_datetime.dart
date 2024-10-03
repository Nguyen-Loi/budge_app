import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

extension HandleDateTime on DateTime {
  String toFormatDate({String strFormat = 'dd-MM-yyyy'}) {
    return DateFormat(strFormat).format(this);
  }

  String toYM() {
    return DateFormat.yMMMM().format(this);
  }

  String toHHmm() {
    return DateFormat.jm().format(this);
  }

  String toTimeAgo(WidgetRef ref) {
    return GetTimeAgo.parse(this,
        locale: ref.read(languageControllerProvider).code);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }

  bool isBetweenDateTimeRange(DateTimeRange rangeDateTime) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(rangeDateTime.start);
    final isBefore = date.isBeforeOrEqualTo(rangeDateTime.end);
    return isAfter && isBefore;
  }

  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;

    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  DateTimeRange get getRangeMonth {
    final date = this;
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1).copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0).copyWith(
        hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
    return DateTimeRange(start: firstDayOfMonth, end: lastDayOfMonth);
  }

  DateTimeRange get getRangeWeek {
    int currentWeekday = weekday;
    DateTime firstDayOfWeek = subtract(Duration(days: currentWeekday - 1))
        .copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    DateTime lastDayOfWeek = add(Duration(days: 7 - currentWeekday)).copyWith(
        hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
    return DateTimeRange(start: firstDayOfWeek, end: lastDayOfWeek);
  }

  DateTimeRange get getRangeYear {
    DateTime firstDayOfYear = DateTime(year, 1, 1).copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    DateTime lastDayOfYear = DateTime(year, 12, 31).copyWith(
        hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
    return DateTimeRange(start: firstDayOfYear, end: lastDayOfYear);
  }
}

extension HandleDateTimeNull on DateTime? {
  String toFormatDate(
      {String strFormat = 'dd-MM-yyyy', String defaultValue = 'NoData'}) {
    if (this == null) {
      return defaultValue;
    }
    return DateFormat(strFormat).format(this!);
  }

  String toHHmm({String defaultValue = 'NoData'}) {
    if (this == null) {
      return defaultValue;
    }
    return DateFormat.jm().format(this!);
  }

  String toTimeAgo({String defaultValue = 'NoData'}) {
    if (this == null) {
      return defaultValue;
    }
    return GetTimeAgo.parse(this!);
  }

  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime);
      final isBefore = date.isBeforeOrEqualTo(toDateTime);
      return isAfter && isBefore;
    }
    return null;
  }
}
