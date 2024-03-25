import 'package:intl/intl.dart';

extension HandleDateTime on DateTime {
  String toFormat({String strFormat = 'dd-MM-yyyy'}) {
    return DateFormat(strFormat).format(this);
  }
}

extension HandleDateTimeNull on DateTime? {
  String toFormat({String strFormat = 'dd-MM-yyyy', String defaultValue='NoData'}) {
    if(this==null){
      return defaultValue;
    }
    return DateFormat(strFormat).format(this!);
  }
}
