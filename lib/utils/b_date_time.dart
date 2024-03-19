import 'package:intl/intl.dart';

class BDateTime {
  static String toFormat(DateTime dateTime, {String strFormat = 'dd/MM/yyyy'}) {
    return DateFormat(strFormat).format(dateTime);
  }
}
