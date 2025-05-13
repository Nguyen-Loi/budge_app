import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_progress_bar.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:flutter/material.dart';

class BudgetExpenseStatus extends StatelessWidget {
  const BudgetExpenseStatus({super.key, required this.budget});
  final BudgetModel budget;
  int get progress {
    final currentAmount = budget.currentAmount.abs();
    final limit = budget.budgetLimit;
    if (currentAmount == 0 && limit == 0) {
      return 0;
    } else if (currentAmount <= limit) {
      return (currentAmount / limit * 100).round();
    } else {
      return 100;
    }
  }

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
