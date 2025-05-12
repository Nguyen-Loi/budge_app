import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, LanguageEnum>((ref) {
  return LanguageController(ref: ref);
});

class LanguageController extends StateNotifier<LanguageEnum> {
  LanguageController({required this.ref}) : super(LanguageEnum.english) {
    state =
        LanguageEnum.fromCode(ref.watch(sharedUtilityProvider).languageCode());
  }
  Ref ref;

  void updateLanguage(LanguageEnum language) async {
    ref.watch(sharedUtilityProvider).setLanguageCode(
          code: language.code,
        );
    UserModel? user = ref.read(userBaseControllerProvider.notifier).state;
    state = language;

    if (user == null) return;
    user = user.copyWith(languageCode: language.code);
    ref.read(userBaseControllerProvider.notifier).updateUser(user);
  }
}
