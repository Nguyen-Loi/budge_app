
enum AccountType {
  emailAndPassword(1),
  facebook(2),
  google(3);
  
  factory AccountType.fromValue (int value){
    return  AccountType.values.firstWhere((e) => e.value==value);
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
