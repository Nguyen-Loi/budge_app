import 'package:budget_app/constants/assets_constants.dart';

enum LanguageEnum {
  english(SvgAssets.en, 'English', 'en'),
  vietnamese(SvgAssets.vi, 'Việt nam', 'vi');

  const LanguageEnum(this.svgAsset, this.name, this.code);

  factory LanguageEnum.fromCode(String code) {
    return LanguageEnum.values.firstWhere((e) => e.code == code);
  }

  final String svgAsset;
  final String name;
  final String code;
}

