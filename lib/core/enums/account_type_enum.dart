enum AccountType {
  anonymous('ANONYMOUS'),
  emailAndPassword('DEFAULT'),
  registeredEmailAndPassword('DEFAULT'),
  facebook('FACEBOOK'),
  google('GOOGLE');

  factory AccountType.fromValue(String value) {
    return AccountType.values.firstWhere((e) => e.value == value);
  }

  final String value;
  const AccountType(this.value);
}

extension ConvertTypeAccount on AccountType {
  String toText() {
    switch (this) {
      case AccountType.emailAndPassword:
      case AccountType.registeredEmailAndPassword:
        return 'Email and password';
      case AccountType.facebook:
        return 'Facebook';
      case AccountType.google:
        return 'Google';
      case AccountType.anonymous:
        return 'Anonymous';
    }
  }
}
