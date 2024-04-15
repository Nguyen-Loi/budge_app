import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_progress_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class GoalStatus extends StatelessWidget {
  const GoalStatus(
      {Key? key,
      required this.goal,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);
  final BudgetModel goal;
  final CrossAxisAlignment crossAxisAlignment;

  int get progress => goal.currentAmount <= goal.limit
      ? (goal.currentAmount / goal.limit * 100).round()
      : 100;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        BProgressBar(
          percent: progress,
          gradient: _gradient(),
        ),
        gapH8,
        BText.b3(
            '${goal.currentAmount.toMoneyStr()}/${goal.limit.toMoneyStr()}')
      ],
    );
  }

  LinearGradient _gradient() {
    switch (goal.status) {
      case StatusBudgetProgress.start:
      case StatusBudgetProgress.progress:
      case StatusBudgetProgress.almostDone:
      case StatusBudgetProgress.complete:
        return ColorManager.linearPrimary;
    }
  }
}
