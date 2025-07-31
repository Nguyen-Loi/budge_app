import 'package:collection/collection.dart';

enum UserRoleEnum {
  normal('NORMAL'),
  premium('PREMIUM');

  factory UserRoleEnum.fromValue(String value) {
    return UserRoleEnum.values.firstWhereOrNull((e) => e.value == value) ??
        UserRoleEnum.normal;
  }

  final String value;
  const UserRoleEnum(this.value);
}

extension ConvertTypeAccount on UserRoleEnum {
  String toText() {
    switch (this) {
      case UserRoleEnum.normal:
        return 'Normal';
      case UserRoleEnum.premium:
        return 'Premium';
    }
  }
}
