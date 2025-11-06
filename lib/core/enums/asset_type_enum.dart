enum AssetTypeEnum {
  avatarImage("AVATAR_IMAGE");

  factory AssetTypeEnum.fromCode(String code) {
    return AssetTypeEnum.values.firstWhere((e) => e.code == code);
  }

  final String code;
  const AssetTypeEnum(this.code);
}
