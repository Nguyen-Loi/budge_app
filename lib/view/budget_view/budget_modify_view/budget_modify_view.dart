import 'package:budget_app/common/widget/bottom_sheet/b_bottom_sheet_range_datetime.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_modify_view/controller/budget_modify_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetModifyView extends StatefulWidget {
  final BudgetModel budgetModel;
  const BudgetModifyView({super.key, required this.budgetModel});

  @override
  State<BudgetModifyView> createState() => _ModifyBudgetViewState();
}

class _ModifyBudgetViewState extends State<BudgetModifyView> {
  late String _iconName;
  late int _limit;
  late DatetimeRangeModel _dateTimeRangeModel;
  final _formKey = GlobalKey<FormState>();
  late BudgetModel _budget;
  late bool _showLimitField;
  late String _budgetName;

  @override
  void initState() {
    _budget = widget.budgetModel;
    _iconName = _budget.iconName;
    _limit = _budget.budgetLimit;
    _budgetName = _budget.name;
    _dateTimeRangeModel = DatetimeRangeModel(
        startDate: _budget.startDate,
        endDate: _budget.endDate,
        rangeDateTimeType: _budget.rangeDateTimeType);
    _showLimitField = _budget.rangeDateTimeType != RangeDateTimeEnum.allTime;
    super.initState();
  }

  void _updateLimitFieldVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showLimitField =
            _dateTimeRangeModel.rangeDateTimeType != RangeDateTimeEnum.allTime;
        if (!_showLimitField) {
          _limit = 0;
        }
      });
    });
  }

  void _updateBudget(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      ref
          .read(
            budgetModifyControllerProvider(_budget).notifier,
          )
          .updateBudget(context,
              budgetName: _budgetName,
              iconName: _iconName,
              limit: _limit,
              dateTimeRange: _dateTimeRangeModel);
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
        child: _form().responsiveCenter(),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          BFormFieldText.init(
              label: context.loc.budgetName,
              hint: context.loc.budgetNameHint,
              initialValue: _budgetName,
              validator: (p0) => p0.validateNotNull(context),
              onChanged: (v) {
                _budgetName = v;
              }),
          gapH16,
          BFormPickerIcon(
            initialValue: IconManagerData.getIconModel(_budget.iconName),
            items: IconManagerData.listIconSelect(),
            onChanged: (value) {
              if (value != null) {
                _iconName = value;
              }
            },
            validator: (p0) {
              if (p0 == null) {
                return context.loc.errorChooseYourBudgetIcon;
              }
              return null;
            },
          ),
          if (_showLimitField) ...[
            gapH16,
            BFormFieldAmount(
                initialValue: _limit,
                label: context.loc.limit,
                onChanged: (v) {
                  if (v != null) {
                    _limit = v;
                  }
                }),
          ],
          gapH16,
          BBottomsheetRangeDatetime(
              initialValue: _dateTimeRangeModel,
              onChanged: (e) {
                _dateTimeRangeModel = e;
                _updateLimitFieldVisibility();
              }),
          gapH16,
          const SizedBox(height: 64),
          Consumer(
            builder: (context, ref, child) {
              return BButton(
                onPressed: () => _updateBudget(ref),
                title: context.loc.update,
              );
            },
          )
        ],
      ),
    );
  }
}
