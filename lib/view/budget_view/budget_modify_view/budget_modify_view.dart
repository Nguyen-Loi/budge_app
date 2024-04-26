import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_custom_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_modify_view/controller/budget_modify_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetModifyView extends ConsumerStatefulWidget {
  final BudgetModel budgetModel;
  const BudgetModifyView({super.key, required this.budgetModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ModifyBudgetViewState();
}

class _ModifyBudgetViewState extends ConsumerState<BudgetModifyView> {
  late int _iconId;
  late int _limit;
  final _formKey = GlobalKey<FormState>();
  late BudgetModel _budget;
  @override
  void initState() {
    _budget = widget.budgetModel;
    _iconId = _budget.iconId;
    _limit = _budget.limit;
    super.initState();
  }

  void _updateBudget() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(
            budgetModifyControllerProvider(_budget),
          )
          .updateBudget(context,
              budget: _budget, iconId: _iconId, limit: _limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView.customBackground(
        title: context.loc.modifyBudget,
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
              label: context.loc.budgetName, initialValue: _budget.name, disable: true),
          gapH16,
          BFormPickerIcon(
            initialValue: IconDataConstant.getIconModel(_budget.iconId),
            items: IconDataConstant.listIcon,
            onChanged: (value) {
              if (value != null) {
                _iconId = value;
              }
            },
            validator: (p0) {
              if (p0 == null) {
                return context.loc.chooseYourBudgetIcon;
              }
              return null;
            },
          ),
          gapH16,
          BFormFieldCustomAmount(
            initialValue: _budget.limit,
            label: context.loc.monthlyLimit,
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
              onPressed: _updateBudget,
              child: BText(context.loc.update, color: ColorManager.white))
        ],
      ),
    );
  }
}
