import 'package:collection/collection.dart';

enum UserRole {
  normal('NORMAL'),
  vip('VIP'),
  prenium('PREMIUM');

  factory UserRole.fromValue(String value) {
    return UserRole.values.firstWhereOrNull((e) => e.value == value)??UserRole.normal;
  }

  final String value;
  const UserRole(this.value);
}

extension ConvertTypeAccount on UserRole {
  String toText() {
    switch (this) {
      case UserRole.normal:
        return 'Normal';
      case UserRole.vip:
        return 'Vip';
      case UserRole.prenium:
        return 'Prenium';
    }
  }
}
