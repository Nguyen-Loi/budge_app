import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/async/b_async_list.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/custom/goal_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:budget_app/view/goals_view/goals_page/controller/goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        gapH40,
        BText.h2('Goals'.hardcoded),
        gapH32,
        Expanded(
          child: _builder(),
        ),
      ],
    );
  }

  Widget _builder() {
    return Consumer(builder: (_, ref, __) {
      return BListAsync.customList(
          data: ref.watch(goalsFutureProvider),
          itemsBuilder: (context, _) {
            ref.watch(goalsControllerProvider);
            final goalDefault =
                ref.watch(goalsControllerProvider.notifier).goalDefault;
            final goalList =
                ref.watch(goalsControllerProvider.notifier).listGoal;
            return ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              children: [
                _urgentMoney(goalDefault),
                gapH16,
                _listGoalCustom(goalList)
              ],
            );
          });
    });
  }

  Widget _listGoalCustom(List<BudgetModel> goals) {
    return Column(
      children: [
        //Title
        Row(
          children: [
             Expanded(
              child: BText.b1('My Saving Plan'),
            ),
            gapW16,
            CircleAvatar(
              backgroundColor: ColorManager.purple25,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutePath.goalNew);
                },
                icon: Icon(IconConstants.add),
              ),
            ),
          ],
        ),
        gapH16,
        // List data
        goals.isEmpty
            ? const BStatus.empty()
            : LayoutBuilder(builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: goals.length,
                  itemBuilder: (_, index) => _cardGoal(goals[index]),
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

  Widget _urgentMoney(BudgetModel goal) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePath.goalDetail, arguments: goal);
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: BText.b1('myUrgentMoney'.hardcoded)),
              gapW16,
              Icon(IconConstants.arrowNext)
            ],
          ),
          gapH16,
          GoalStatus(goal: goal, crossAxisAlignment: CrossAxisAlignment.end)
        ],
      ),
    );
  }

  Widget _cardGoal(BudgetModel goal) {
    IconModel icon = IconDataConstant.getIconModel(goal.iconId);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePath.goalDetail, arguments: goal);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon.iconData, color: icon.color),
              gapH16,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      ),
    );
  }
}
