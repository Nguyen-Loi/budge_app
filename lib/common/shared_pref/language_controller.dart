import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, LanguageEnum>((ref) {
  return LanguageController(ref: ref);
});

class LanguageController extends StateNotifier<LanguageEnum> {
  LanguageController({required this.ref}) : super(LanguageEnum.vietnamese) {
    state =
        LanguageEnum.fromCode(ref.watch(sharedUtilityProvider).languageCode());
  }
  Ref ref;

  void updateLanguage(LanguageEnum language) {
    ref.watch(sharedUtilityProvider).setLanguageCode(
          code: language.code,
        );
    state = language;
  }
}
