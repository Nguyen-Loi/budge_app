import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final isDarkControllerProvider = NotifierProvider<ThemeController, bool>(ThemeController.new);

class ThemeController extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(sharedUtilityProvider).isDarkModeEnabled();
  }

  void toggleTheme() {
    bool isDark = ref.watch(sharedUtilityProvider).isDarkModeEnabled();
    ref.watch(sharedUtilityProvider).setDarkModeEnabled(
          isdark: !isDark,
        );
    state = !isDark;
  }
}
