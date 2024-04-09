import 'package:uuid/uuid.dart';

Uuid _uuid = const Uuid();

class RandomId {
  RandomId._();

  static String get time => _uuid.v1();
  static String get random => _uuid.v4();
}
