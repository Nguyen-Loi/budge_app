import 'package:budget_app/view/auth_view/forgot_password.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/auth_view/sign_up_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_view.dart';
import 'package:budget_app/view/budget_view/budget_modify_view/budget_modify_view.dart';
import 'package:budget_app/view/budget_view/budget_new_view/new_budget_view.dart';
import 'package:budget_app/view/chat_view/chat_view.dart';
import 'package:budget_app/view/contact_view/contact_view.dart';
import 'package:budget_app/view/onboaring_view/onboarding_screen.dart';
import 'package:budget_app/view/feedback_view/feedback_view.dart';
import 'package:budget_app/view/main_page_view/main_page_view.dart';
import 'package:budget_app/view/new_transaction_view/new_transaction_view.dart';
import 'package:budget_app/view/profile_view/profile_view.dart';
import 'package:budget_app/view/settings_view/settings_view.dart';
import 'package:budget_app/view/subscription_view/subscription_view.dart';
import 'package:flutter/material.dart';

class RoutePath {
  RoutePath._();
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/forgotPassword";
  static const String home = "/home";
  static const String onboarding = "/onboarding";

  static const String newBudget = "/newBudget";
  static const String budgetDetail = "/budgetDetail";
  static const String budgetModify = "/budgetModify";

  static const String newTransaction = "/newTransaction";

  static const String profile = "/profile";
  static const String feedback = "/feedback";

  //Base
  static const String settings = "/settings";
  static const String report = "/report";
  static const String chat = "/chat";
  static const String contact = "/contact";
  static const String subscription = "/subscription";
}

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RoutePath.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case RoutePath.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case RoutePath.home:
        return MaterialPageRoute(builder: (_) => const MainPageView());
      case RoutePath.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case RoutePath.newBudget:
        return MaterialPageRoute(builder: (_) => const NewBudgetView());
      case RoutePath.budgetDetail:
        final budgetId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => BudgetDetailView(budgetId: budgetId));
      case RoutePath.budgetModify:
        final budgetId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => BudgetModifyView(budgetId: budgetId));

      case RoutePath.newTransaction:
        return MaterialPageRoute(builder: (_) => const NewTransactionView());

      case RoutePath.profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case RoutePath.feedback:
        return MaterialPageRoute(builder: (_) => const FeedbackView());

      case RoutePath.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case RoutePath.chat:
        return MaterialPageRoute(builder: (_) => const ChatView());
      case RoutePath.contact:
        return MaterialPageRoute(builder: (_) => const ContactView());
      case RoutePath.subscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionView());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
