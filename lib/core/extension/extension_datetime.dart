import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

extension HandleDateTime on DateTime {
  String toFormatDate({String strFormat = 'dd-MM-yyyy'}) {
    return DateFormat(strFormat).format(this);
  }

  String toHHmm() {
    return DateFormat.jm().format(this);
  }

   String toTimeAgo() {
    return GetTimeAgo.parse(this);
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
