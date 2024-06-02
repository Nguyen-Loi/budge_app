import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/auth_view/sign_up_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_view.dart';
import 'package:budget_app/view/budget_view/budget_modify_view/budget_modify_view.dart';
import 'package:budget_app/view/budget_view/budget_new_view/new_budget_view.dart';
import 'package:budget_app/view/main_page_view/main_page_view.dart';
import 'package:budget_app/view/new_transaction_view/new_transaction_view.dart';
import 'package:budget_app/view/profile_view/profile_detail/profile_detail_view.dart';
import 'package:budget_app/view/report_view/report_view.dart';
import 'package:budget_app/view/settings_view/settings_view.dart';
import 'package:budget_app/view/update_wallet_view/update_wallet_view.dart';
import 'package:flutter/material.dart';

class RoutePath {
  RoutePath._();
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String home = "/home";

  static const String newBudget = "/newBudget";
  static const String budgetDetail = "/budgetDetail";
  static const String budgetModify = "/budgetModify";

  static const String newTransaction = "/newTransaction";

  static const String profileDetail = "/profileDetail";
  static const String updateWallet = "/updateWallet";

  //Base
  static const String settings = "/settings";
  static const String report = "/report";
}

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RoutePath.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case RoutePath.home:
        return MaterialPageRoute(builder: (_) => const MainPageView());

      case RoutePath.newBudget:
        return MaterialPageRoute(builder: (_) => const NewBudgetView());
      case RoutePath.budgetDetail:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(
            builder: (_) => BudgetDetailView(budget: data));
      case RoutePath.budgetModify:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(
            builder: (_) => BudgetModifyView(budgetModel: data));

      case RoutePath.newTransaction:
        return MaterialPageRoute(builder: (_) => const NewTransactionView());

      case RoutePath.profileDetail:
        return MaterialPageRoute(builder: (_) => const ProfileDetailView());
      case RoutePath.updateWallet:
        return MaterialPageRoute(builder: (_) => const UpdateWalletView());

      case RoutePath.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case RoutePath.report:
        return MaterialPageRoute(builder: (_) => const ReportView());

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
