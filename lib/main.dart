import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/theme/app_theme.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/main_page_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart'; // generated via `flutterfire` CLI

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.lightTheme,
      onGenerateRoute: MainRouter.generateRoute,
      home: ref.read(authControllerProvider.notifier).isLogin
          ? const MainPageBottomBar()
          : const LoginView(),
    );
  }
}
