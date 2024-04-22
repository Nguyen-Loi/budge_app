import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/auth_view/login_view.dart';
import 'package:budget_app/view/auth_view/sign_up_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_view.dart';
import 'package:budget_app/view/budget_view/budget_modify_view/budget_modify_view.dart';
import 'package:budget_app/view/budget_view/budget_new_view/budget_new_view.dart';
import 'package:budget_app/view/goals_view/goal_detail_view/goal_detail_view.dart';
import 'package:budget_app/view/goals_view/goal_modify_view/goal_modify_view.dart';
import 'package:budget_app/view/goals_view/goal_new_view/goal_new_view.dart';
import 'package:budget_app/view/income_view/income_view.dart';
import 'package:budget_app/view/main_page_bottom_bar.dart';
import 'package:budget_app/view/new_expense_view/new_expense_view.dart';
import 'package:budget_app/view/profile_view/profile_detail/profile_detail_view.dart';
import 'package:budget_app/view/settings_view/settings_view.dart';
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
  static const String budgetNew = "/budgetNew";
  static const String budgetDetail = "/budgetDetail";
  static const String budgetModify = "/budgetModify";
  static const String goalNew = "/newGoal";
  static const String goalDetail = "/goalDetail";
  static const String goalModify = "/goalModify";
  static const String profileDetail = "/profileDetail";

  //Base
  static const String settings = "/settings";
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

      case RoutePath.income:
        return MaterialPageRoute(builder: (_) => const IncomeView());
      case RoutePath.expense:
        return MaterialPageRoute(builder: (_) => const NewExpenseView());
      case RoutePath.budgetNew:
        return MaterialPageRoute(builder: (_) => const BudgetNewView());
      case RoutePath.budgetDetail:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(
            builder: (_) => BudgetDetailView(budget: data));
      case RoutePath.budgetModify:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(
            builder: (_) => BudgetModifyView(budgetModel: data));
      case RoutePath.goalNew:
        return MaterialPageRoute(builder: (_) => const GoalNewView());
      case RoutePath.goalDetail:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(builder: (_) => GoalDetailView(goal: data));
      case RoutePath.goalModify:
        final data = settings.arguments as BudgetModel;
        return MaterialPageRoute(
            builder: (_) => GoalModifyView(goalModel: data));
      case RoutePath.profileDetail:
        return MaterialPageRoute(builder: (_) => const ProfileDetailView());

      case RoutePath.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());

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
