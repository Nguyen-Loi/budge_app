extension ValidateForm on String? {
  String? get validateEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    String textError = 'Email invalid';
    if (this == null || !emailRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validateNotNull {
    String textError = 'Data emtpy';
    if (this == null) {
      return textError;
    }
    return null;
  }

  String? get validatePhoneNumber {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    String textError = 'Phone number invalid';
    if (this == null || !phoneRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validateName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    String textError = 'Name invalid';
    if (this == null || !nameRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validatePassword {
    String textError = 'Password minimum is 6 characters';
    if (this == null || this!.length < 6) {
      return textError;
    }
    return null;
  }

  String? validateInteger({String textError = 'Invalid'}) {
    final intRegExp = RegExp(r'^[0-9]+$');
    if (this == null || !intRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? validateMatchPassword(String password) {
    String textError = 'Confirm password invalid';
    if (this == null || this! != password) {
      return textError;
    }
    return null;
  }
}
