import 'dart:io';

import 'package:budget_app/core/enums/language_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedUtility(sharedPreferences: sharedPrefs);
});

const String _darkModeKey = 'darkMode';
const String _languageCodeKey = 'language_code';

class SharedUtility {
  SharedUtility({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool isDarkModeEnabled() {
    return sharedPreferences.getBool(_darkModeKey) ?? false;
  }

  void setDarkModeEnabled({required bool isdark}) {
    sharedPreferences.setBool(_darkModeKey, isdark);
  }

  String languageCode() {
    final defaultLanguage = Platform.localeName.split('_')[0];
    LanguageEnum languageEnumDefault =
        defaultLanguage == 'vi' ? LanguageEnum.vietnamese : LanguageEnum.english;
    return sharedPreferences.getString(_languageCodeKey) ??
        languageEnumDefault.code;
  }

  void setLanguageCode({required String code}) {
    sharedPreferences.setString(_languageCodeKey, code);
  }
}
