class AssetsConstants {
  static const String _imagePath = 'assets/images';
  static const String _avatarImagePath = '$_imagePath/avatar';

  static const String avatarDefault = '$_imagePath/avatar_default.png';

  static const String avatar1 = '$_avatarImagePath/1.png';
  static const String avatar2 = '$_avatarImagePath/2.png';
  static const String avatar3 = '$_avatarImagePath/3.png';
  static const String avatar4 = '$_avatarImagePath/4.png';
  static const String avatar5 = '$_avatarImagePath/5.png';
  static const String avatar6 = '$_avatarImagePath/6.png';
  static const String avatar7 = '$_avatarImagePath/7.png';
  static const String avatar8 = '$_avatarImagePath/8.png';
  static const String avatar9 = '$_avatarImagePath/9.png';
  static const String avatar10 = '$_avatarImagePath/10.png';
  static const String avatar11 = '$_avatarImagePath/11.png';
  static const String avatar12 = '$_avatarImagePath/12.png';
  static const String avatar13 = '$_avatarImagePath/13.png';
  static const String avatar14 = '$_avatarImagePath/14.png';
  static const String avatar15 = '$_avatarImagePath/15.png';
  static const String avatar16 = '$_avatarImagePath/16.png';

  /// List of all available avatar assets
  static const List<String> allAvatars = [
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
    avatar6,
    avatar7,
    avatar8,
    avatar9,
    avatar10,
    avatar11,
    avatar12,
    avatar13,
    avatar14,
    avatar15,
    avatar16,
  ];

  /// Returns the default avatar (avatar1) if null or empty
  static String getDefaultAvatar() => avatar1;
}

class LottieAssets {
  static const String _lottiePath = 'assets/lottie';
  static const String loading1 = '$_lottiePath/loading1.json';
  static const String loading2 = '$_lottiePath/loading2.json';
  static const String loadingImage = '$_lottiePath/loadingImage.json';
  static const String error = '$_lottiePath/error.json';
  static const String empty = '$_lottiePath/empty.json';
}

class SvgAssets {
  static const String _svgsPath = 'assets/svgs';
  static const String google = '$_svgsPath/google.svg';
  static const String expired = '$_svgsPath/expired.svg';
  static const String coming = '$_svgsPath/coming.svg';
  static const String active = '$_svgsPath/active.svg';
  static const String status = '$_svgsPath/status.svg';
  static const String operatingTime = '$_svgsPath/operatingTime.svg';
  static const String money = '$_svgsPath/money.svg';
  static const String limit = '$_svgsPath/limit.svg';
  static const String iconApp = '$_svgsPath/icon.svg';
  static const String iconBotApp = '$_svgsPath/chatIcon.svg';
  static const String vi = '$_svgsPath/vi.svg';
  static const String en = '$_svgsPath/en.svg';
  static const String wallet = '$_svgsPath/wallet.svg';
}
