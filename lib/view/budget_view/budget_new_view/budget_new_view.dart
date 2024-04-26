import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_custom_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_data_constant.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_new_view/controller/budget_new_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetNewView extends ConsumerStatefulWidget {
  const BudgetNewView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetNewViewState();
}

class _BudgetNewViewState extends ConsumerState<BudgetNewView> {
  late TextEditingController _budgetNameController;
  late int _iconId;
  late int _limit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _budgetNameController = TextEditingController();
    super.initState();
  }

  void _addNewBudget() {
    if (_formKey.currentState!.validate()) {
      ref.read(budgetNewControllerProvider).addBudget(context,
          budgetName: _budgetNameController.text,
          iconId: _iconId,
          limit: _limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView.customBackground(
        title: context.loc.newBudget,
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
            _budgetNameController,
            label: context.loc.budgetName,
            hint: context.loc.budgetNameHint,
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
                return context.loc.chooseYourBudgetIcon;
              }
              return null;
            },
          ),
          gapH16,
          BFormFieldCustomAmount(
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
              onPressed: _addNewBudget,
              child: BText(context.loc.add, color: ColorManager.white))
        ],
      ),
    );
  }
}
