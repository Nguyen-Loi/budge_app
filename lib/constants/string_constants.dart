import 'package:budget_app/core/utils.dart';

class StringConstants {
  StringConstants._();
  static const String emailDefault = 'guest@example.com';
  static const String profileUrlDefault =
      'https://firebasestorage.googleapis.com/v0/b/budget-ss.appspot.com/o/assets%2FAVATAR_IMAGE%2F13.jpg?alt=media&token=fbb5f800-17c0-4c45-850a-331e229325d0';
  static const String budgetDefaultKeyPrefix = 'DEFAULT_';

  static String setName({required String name, required String email}) {
    List<String> nameDefaults = [
      'GUEST',
      'KHÁCH',
    ];
    if (nameDefaults.contains(name.toUpperCase())) {
      return getNameFromEmail(email);
    }
    return name;
  }
}

class SettingConstants {
  static const int datePreniumForNewUser = 7;
}
