import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/bottom_sheet/b_bottom_sheet_range_datetime.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_new_view/controller/new_budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewBudgetView extends ConsumerStatefulWidget {
  const NewBudgetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetNewViewState();
}

class _BudgetNewViewState extends ConsumerState<NewBudgetView> {
  late TextEditingController _budgetNameController;

  late int _iconId;
  late int _limit;
  late DatetimeRangeModel _rangeDatetimeModel;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _budgetNameController = TextEditingController();
    _limit = 0;
    super.initState();
  }

  void _addNewBudget() {
    if (_formKey.currentState!.validate()) {
      ref.read(newBudgetControllerProvider).addBudget(context,
          budgetName: _budgetNameController.text,
          rangeDatetimeModel: _rangeDatetimeModel,
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
            validator: (p0) => p0.validateNotNull(context),
          ),
          gapH16,
          BFormPickerIcon(
            items: IconManagerData.listIconSelect(),
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
          BFormFieldAmount(
            label: 'Limit'.hardcoded,
            onChanged: (e) {
              if (e != null) {
                _limit = e;
              }
            },
          ),
          gapH16,
          BBottomsheetRangeDatetime(
              initialValue: RangeDateTimeEnum.month,
              onChanged: (e) {
                _rangeDatetimeModel = e;
              }),
          const SizedBox(height: 64),
          FilledButton(
              onPressed: _addNewBudget,
              child: BText(context.loc.add, color: ColorManager.white))
        ],
      ),
    );
  }
}
