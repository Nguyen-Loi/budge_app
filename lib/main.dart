import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/shared_pref/theme_controller.dart';
import 'package:budget_app/core/logger_observer.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/theme/app_theme.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/main_page_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart'; // generated via `flutterfire` CLI

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    observers: [
      LoggerObserver(),
    ],
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageControllerProvider);
    final isDark = ref.watch(isDarkControllerProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: MainRouter.generateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Locale(language.code),
      supportedLocales: AppLocalizations.supportedLocales,
      home: ref.watch(authControllerProvider.notifier).isLogin
          ? const MainPageBottomBar()
          : const LoginView(),
    );
  }
}
