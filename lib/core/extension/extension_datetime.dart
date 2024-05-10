import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

extension HandleDateTime on DateTime {
  String toFormatDate({String strFormat = 'dd-MM-yyyy'}) {
    return DateFormat(strFormat).format(this);
  }

  String toHHmm() {
    return DateFormat.jm().format(this);
  }

  String toTimeAgo(WidgetRef ref) {
    return GetTimeAgo.parse(this, locale: ref.read(languageControllerProvider).code);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
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
}
