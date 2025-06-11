import 'package:budget_app/constants/assets_constants.dart';

enum LanguageEnum {
  english(SvgAssets.en, 'English', 'en', '+1', 'EN'),
  vietnamese(SvgAssets.vi, 'Việt nam', 'vi', '+84', 'VN'),
  ;

  const LanguageEnum(this.svgAsset, this.name, this.code, this.dialCode, this.isoCode);

  factory LanguageEnum.fromCode(String code) {
    return LanguageEnum.values.firstWhere((e) => e.code == code);
  }

  final String svgAsset;
  final String name;
  final String code;
  final String dialCode;
  final String isoCode;
}
