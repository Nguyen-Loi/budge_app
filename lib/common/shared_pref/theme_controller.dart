import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final isDarkControllerProvider = StateNotifierProvider<ThemeController, bool>((ref) {
  return ThemeController(ref: ref);
});
class ThemeController extends StateNotifier<bool> {
  ThemeController({required this.ref}) : super(false) {
    state = ref.watch(sharedUtilityProvider).isDarkModeEnabled();
  }
  Ref ref;

  void toggleTheme() {
    bool isDark = ref.watch(sharedUtilityProvider).isDarkModeEnabled();
    ref.watch(sharedUtilityProvider).setDarkModeEnabled(
          isdark: !isDark,
        );
    state = !isDark;
  }
}
