import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/table_constant.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/custom/goal_status.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/data/goal_data.dart';
import 'package:budget_app/models/goal_model.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class GoalsView extends StatelessWidget {
  GoalsView({super.key});
  List<GoalModel> list = GoalData.listItem;

  GoalModel get urgentGoal =>
      list.firstWhereOrNull((e) => e.isUrgent) ?? _defaultUrgent;

  GoalModel get _defaultUrgent => GoalModel({
        FieldConstants.name: GoalModel.strUrgentMain,
        FieldConstants.iconId: 1,
        FieldConstants.limit: 300,
        FieldConstants.currentAmount: 100,
        TableConstant.goalTransaction: []
      });

  List<GoalModel> get listGoalCustom => list.where((e) => !e.isUrgent).toList();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapH40,
        const BText.h2('Goals'),
        gapH32,
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            children: [
              _urgentMoney(),
              gapH16,
              _listGoalCustom(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listGoalCustom() {
    List<GoalModel> listGoal = listGoalCustom;
    return Column(
      children: [
        //Title
        Row(
          children: [
            const Expanded(
              child: BText.b1('My Saving Plan'),
            ),
            gapW16,
            CircleAvatar(
              backgroundColor: ColorManager.purple25,
              child: IconButton(
                onPressed: () {},
                icon: Icon(IconConstants.add),
              ),
            ),
          ],
        ),
        gapH16,
        // List data
        LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listGoal.length,
            itemBuilder: (_, index) => _cardGoal(listGoal[index]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 700 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
          );
        })
      ],
    );
  }

  Widget _urgentMoney() {
    GoalModel goal = urgentGoal;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: BText.b1('My Urgent Money')),
            gapW16,
            Icon(IconConstants.arrowNext)
          ],
        ),
        gapH16,
        GoalStatus(goal: goal, crossAxisAlignment: CrossAxisAlignment.end)
      ],
    );
  }

  Widget _cardGoal(GoalModel goal) {
    IconModel icon = IconDataConstant.getIconModel(goal.iconId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon.iconData, color: icon.color),
            gapH16,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: ColorManager.grey2,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: BText.b3(goal.name, color: icon.color),
            ),
            gapH16,
            GoalStatus(goal: goal)
          ],
        ),
      ),
    );
  }
}
