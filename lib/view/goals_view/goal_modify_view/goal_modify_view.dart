import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_custom_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/goals_view/goal_modify_view/controller/goal_modify_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalModifyView extends ConsumerStatefulWidget {
  final BudgetModel goalModel;
  const GoalModifyView({super.key, required this.goalModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ModifyBudgetViewState();
}

class _ModifyBudgetViewState extends ConsumerState<GoalModifyView> {
  late int _iconId;
  late int _limit;
  final _formKey = GlobalKey<FormState>();
  late BudgetModel _goal;
  @override
  void initState() {
    _goal = widget.goalModel;
    _iconId = _goal.iconId;
    _limit = _goal.limit;
    super.initState();
  }

  void _updateGoal() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(
            goalModifyControllerProvider(_goal),
          )
          .updateBudget(context, budget: _goal, iconId: _iconId, limit: _limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView.customBackground(
        title: context.loc.modifyGoal,
        buildTop: gapH32,
        child: _form(),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          BFormFieldText.init(
              label: context.loc.goalName, initialValue: _goal.name, disable: true),
          gapH16,
          BFormPickerIcon(
            initialValue: IconDataConstant.getIconModel(_goal.iconId),
            items: IconDataConstant.listIcon,
            onChanged: (value) {
              if (value != null) {
                _iconId = value;
              }
            },
            validator: (p0) {
              if (p0 == null) {
                return context.loc.chooseYourGoalIcon;
              }
              return null;
            },
          ),
          gapH16,
          BFormFieldCustomAmount(
            initialValue: _goal.limit,
            label: context.loc.limit,
            onChanged: (v) {
              _limit = v;
            },
            validator: (value) {
              if (value == null) {
                return context.loc.amountInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 64),
          FilledButton(
              onPressed: _updateGoal,
              child: BText(context.loc.update, color: ColorManager.white))
        ],
      ),
    );
  }
}
