import 'package:collection/collection.dart';

enum UserRoleEnum {
  normal('NORMAL'),
  prenium('PRENIUM');

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
      case UserRoleEnum.prenium:
        return 'Prenium';
    }
  }
}
