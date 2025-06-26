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
const String _defaultBudgetsCreatedKey = 'default_budgets_created';
const String _dataFirstTime = 'data_first_time';
const String _inAppReviewPromptCountKey = 'in_app_review_prompt_count';
const String _userTransactionCountKey = 'user_transaction_count';

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
    LanguageEnum languageEnumDefault = defaultLanguage == 'vi'
        ? LanguageEnum.vietnamese
        : LanguageEnum.english;
    return sharedPreferences.getString(_languageCodeKey) ??
        languageEnumDefault.code;
  }

  void setLanguageCode({required String code}) {
    sharedPreferences.setString(_languageCodeKey, code);
  }

  bool areDefaultBudgetsCreated() {
    return sharedPreferences.getBool(_defaultBudgetsCreatedKey) ?? false;
  }

  void markDefaultBudgetsAsCreated() {
    sharedPreferences.setBool(_defaultBudgetsCreatedKey, true);
  }

  Future<void> resetDefaultBudgetsFlag() async {
    await sharedPreferences.remove(_defaultBudgetsCreatedKey);
  }

  Future<void> reset() async {
    await sharedPreferences.clear();
  }

  bool isDataFirstTime() {
    return sharedPreferences.getBool(_dataFirstTime) ?? true;
  }

  void setDataFirstTimeIsFalse() {
    sharedPreferences.setBool(_dataFirstTime, false);
  }

  // App Review methods
  int getInAppReviewPromptCount() {
    return sharedPreferences.getInt(_inAppReviewPromptCountKey) ?? 0;
  }

  Future<void> incrementInAppReviewPromptCount() async {
    final currentCount = getInAppReviewPromptCount();
    await sharedPreferences.setInt(
        _inAppReviewPromptCountKey, currentCount + 1);
  }

  int getUserTransactionCount() {
    return sharedPreferences.getInt(_userTransactionCountKey) ?? 0;
  }

  Future<void> incrementUserTransactionCount() async {
    final currentCount = getUserTransactionCount();
    await sharedPreferences.setInt(_userTransactionCountKey, currentCount + 1);
  }

  Future<void> resetTransactionCount() async {
    await sharedPreferences.remove(_userTransactionCountKey);
  }
}
