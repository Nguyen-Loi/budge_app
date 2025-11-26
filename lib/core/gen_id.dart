import 'package:budget_app/constants/string_constants.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:uuid/uuid.dart';

Uuid _uuid = const Uuid();

class GenId {
  GenId._();

  static String get _time => _uuid.v1();
  static String get uuid => _uuid.v4();
  // static String get _random => _uuid.v4();
  // static String get _currentMonth {
  //   final DateTime now = DateTime.now();
  //   final month = DateTime(now.year, now.month).millisecondsSinceEpoch;
  //   return month.toString();
  // }
  static String budget() => _time;
  static String budgetDefault(String key) =>
      StringConstants.budgetDefaultKeyPrefix + key;
  static String device() => _time;
  static String budgetWallet() => 'WALLET';
  static String transaction() => _time;
  static String chat(RoleChatEnum role) => '${_time}_${role.value}';
  static String devices(String uid) => uid + _time;
  static String feedback() => _time;
  static String subscription() => _time;
  static String asset() => uuid;
}
