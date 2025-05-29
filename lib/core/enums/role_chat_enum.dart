enum RoleChatEnum {
  user('user'),
  assistant('assistant');

  static RoleChatEnum fromValue(String value) {
    return RoleChatEnum.values.firstWhere((e) => e.value == value,
        orElse: () => RoleChatEnum.assistant);
  }

  const RoleChatEnum(this.value);

  final String value;
}

