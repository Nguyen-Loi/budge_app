import 'package:collection/collection.dart';

enum AccountType {
  emailAndPassword(1),
  facebook(2),
  google(3);
  
  static AccountType fromValue (int value){
    return  AccountType.values.firstWhereOrNull((e) => e.value==value)??AccountType.emailAndPassword;
  }

  final int value;
  const AccountType(this.value);
}

extension ConvertTypeAccount on AccountType {
  String toText() {
    switch (this) {
      case AccountType.emailAndPassword:
        return 'Email and password';
      case AccountType.facebook:
        return 'Facebook';
      case AccountType.google:
        return 'Google';
    }
  }
}
