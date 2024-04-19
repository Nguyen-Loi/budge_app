import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_custom_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/goals_view/goal_new_view/controller/goal_new_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalNewView extends ConsumerStatefulWidget {
  const GoalNewView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewBudgetViewState();
}

class _NewBudgetViewState extends ConsumerState<GoalNewView> {
  late TextEditingController _goalNameController;
  late int _iconId;
  late int _limit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _goalNameController = TextEditingController();
    super.initState();
  }

  void _addNewGoal() {
    if (_formKey.currentState!.validate()) {
      ref.read(newGoalControllerProvider).addGoal(context,
          goalName: _goalNameController.text, iconId: _iconId, limit: _limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView.customBackground(
        title: 'New Goal',
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
          BFormFieldText(
            _goalNameController,
            label: 'Goal Name',
            hint: 'Iphone 15 prm',
            validator: (p0) => p0.validateNotNull,
          ),
          gapH16,
          BFormPickerIcon(
            items: IconDataConstant.listIcon,
            onChanged: (value) {
              if (value != null) {
                _iconId = value;
              }
            },
            validator: (p0) {
              if (p0 == null) {
                return 'Please choose your goal icon';
              }
              return null;
            },
          ),
          gapH16,
          BFormFieldCustomAmount(
            label: 'Target',
            onChanged: (v) {
              _limit = v;
            },
            validator: (value) {
              if (value == null) {
                return 'Number invalid';
              }
              return null;
            },
          ),
          const SizedBox(height: 64),
          FilledButton(
              onPressed: _addNewGoal,
              child: BText('Add', color: ColorManager.white))
        ],
      ),
    );
  }
}
