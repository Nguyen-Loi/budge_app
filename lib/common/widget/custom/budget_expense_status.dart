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

  // Get status based on progress percentage
  StatusBudgetProgress get dynamicStatus {
    if (progress <= 25) {
      return StatusBudgetProgress.start;
    } else if (progress <= 50) {
      return StatusBudgetProgress.progress;
    } else if (progress < 100) {
      return StatusBudgetProgress.almostDone;
    } else {
      return StatusBudgetProgress.complete;
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
    switch (dynamicStatus) {
      case StatusBudgetProgress.start:
        // 0-25%: Cool blue gradient
        return const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      case StatusBudgetProgress.progress:
        // 26-50%: Green gradient
        return const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      case StatusBudgetProgress.almostDone:
        // 51-99%: Orange/amber gradient
        return const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      case StatusBudgetProgress.complete:
        // 100%+: Red gradient
        return const LinearGradient(
          colors: [Color(0xFFEF5350), Color(0xFFE53935)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
    }
  }
}
