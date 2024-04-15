import 'package:uuid/uuid.dart';

Uuid _uuid = const Uuid();

class GetId {
  GetId._();

  static String get time => _uuid.v1();
  static String get random => _uuid.v4();
  static String get month {
    final DateTime now = DateTime.now();
    final month = DateTime(now.year, now.month).millisecondsSinceEpoch;
    return month.toString();
  }
}
