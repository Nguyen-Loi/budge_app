import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/shared_pref/theme_controller.dart';
import 'package:budget_app/core/crashlytics.dart';
import 'package:budget_app/core/logger_observer.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/src/b_notification.dart';
import 'package:budget_app/theme/app_theme.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/main_page_view/main_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart'; // generated via `flutterfire` CLI

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  logInfo("Handling a background message: ${message.toMap().toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final sharedPreferences = await SharedPreferences.getInstance();
  _initServices();
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

Future<void> _initServices() async {

  // Manage error
  Crashlytics crashlytics = Crashlytics();
  await crashlytics.initialize();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // Init notification
    ref.read(notificationProvider).initialize();
    // Inin language firebase
    FirebaseAuth.instance.setLanguageCode(ref.read(languageControllerProvider).code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          ? const MainPageView()
          : const LoginView(),
    );
  }
}
