import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/auth_view/sign_up_view.dart';
import 'package:budget_app/view/budget_detail/budget_detail_view.dart';
import 'package:budget_app/view/expense_view/expense_view.dart';
import 'package:budget_app/view/goals_view/goals_view.dart';
import 'package:budget_app/view/income_view/income_view.dart';
import 'package:budget_app/view/main_page_bottom_bar.dart';
import 'package:budget_app/view/new_budget_view/new_budget_view.dart';
import 'package:budget_app/view/profile_view/profile_detail/profile_detail_view.dart';
import 'package:flutter/material.dart';

class RoutePath {
  RoutePath._();
  static const String login = "/login";
  static const String signUp = "/signUp";
  // static const String splash = "/";

  static const String home = "/home";
  static const String goal = "/goal";
  static const String income = "/income";
  static const String expense = "/expense";
  static const String newLimit = "/newLimit";
  static const String profileDetail = "/profileDetail";
  static const String budgetDetail = "/budgetDetail";
}

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RoutePath.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case RoutePath.home:
        return MaterialPageRoute(builder: (_) => const MainPageBottomBar());

      case RoutePath.goal:
        return MaterialPageRoute(builder: (_) => GoalsView());
      case RoutePath.income:
        return MaterialPageRoute(builder: (_) => const IncomeView());
      case RoutePath.expense:
        return MaterialPageRoute(builder: (_) => const ExpenseView());
      case RoutePath.newLimit:
        return MaterialPageRoute(builder: (_) => const NewBudgetView());
      case RoutePath.profileDetail:
        return MaterialPageRoute(builder: (_) => const ProfileDetailView());
      case RoutePath.budgetDetail:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(
            builder: (_) => BudgetDetailView(budget: data));

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
