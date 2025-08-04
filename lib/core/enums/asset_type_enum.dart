enum AssetTypeEnum {
  avatarImage("AVATAR_IMAGE"),
  lottieJson("LOTTIE_JSON"),;

  factory AssetTypeEnum.fromCode(String code) {
    return AssetTypeEnum.values.firstWhere((e) => e.code == code);
  }

  final String code;
  const AssetTypeEnum(this.code);
}
