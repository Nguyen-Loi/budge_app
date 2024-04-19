import 'package:uuid/uuid.dart';

Uuid _uuid = const Uuid();

class GenId {
  GenId._();

  static String get _time => _uuid.v1();
  // static String get _random => _uuid.v4();
  static String get _currentMonth {
    final DateTime now = DateTime.now();
    final month = DateTime(now.year, now.month).millisecondsSinceEpoch;
    return month.toString();
  }

  static String get income => _time;
  static String get statistical => _currentMonth;
  static String budget(String budgetName) =>
      'budget-$_currentMonth-$budgetName';
  static String goal(String goalName) => 'goal-$goalName';
}
