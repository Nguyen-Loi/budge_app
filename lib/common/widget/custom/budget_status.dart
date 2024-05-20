import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_progress_bar.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class BudgetStatus extends StatelessWidget {
  const BudgetStatus({super.key, required this.budget});
  final BudgetModel budget;
  int get progress => budget.currentAmount <= budget.limit
      ? (budget.currentAmount / budget.limit * 100).round()
      : 100;
  @override
  Widget build(BuildContext context) {
    return BProgressBar(
      percent: progress,
      gradient: _gradient(),
    );
  }

  LinearGradient _gradient() {
    switch (budget.status) {
      case StatusBudgetProgress.start:
        return ColorManager.linearGrey;
      case StatusBudgetProgress.progress:
        return ColorManager.linearGreen1;
      case StatusBudgetProgress.almostDone:
        return ColorManager.linearWarning;
      case StatusBudgetProgress.complete:
        return ColorManager.linearDanger;
    }
  }
}
