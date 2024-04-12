import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_modify_limit.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/new_budget_view/new_budget_controller/new_budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewBudgetView extends ConsumerStatefulWidget {
  const NewBudgetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewBudgetViewState();
}

class _NewBudgetViewState extends ConsumerState<NewBudgetView> {
  late TextEditingController _budgetNameController;
  late int iconId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _budgetNameController = TextEditingController();
    super.initState();
  }

  void _addNewBudget() {
    if (_formKey.currentState!.validate()) {
      ref.read(newBudgetControllerProvider).addBudget(context,
          budgetName: _budgetNameController.text, iconId: iconId, limit: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView.customBackground(
      title: 'New Budget',
      buildTop: gapH32,
      child: _form(),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          BFormFieldText(
            _budgetNameController,
            label: 'Budget Name',
            hint: 'Water',
            validator: (p0) => p0.validateNotNull,
          ),
          gapH16,
          BFormPickerIcon(
            items: IconDataConstant.listIcon,
            onChanged: (value) {
              if (value != null) {
                iconId = value;
                logSuccess(value.toString());
              }
            },
            validator: (p0) {
              if (p0 == null) {
                return 'Please choose your budget icon';
              }
              return null;
            },
          ),
          gapH16,
          BFormModifyLimit(
            onChanged: (v) {
              logSuccess(v.toString());
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
              onPressed: _addNewBudget,
              child: BText('Add', color: ColorManager.white))
        ],
      ),
    );
  }
}
