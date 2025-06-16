import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/bottom_sheet/b_bottom_sheet_range_datetime.dart';
import 'package:budget_app/common/widget/form/b_form_budget_type.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_new_view/controller/new_budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewBudgetView extends StatefulWidget {
  const NewBudgetView({super.key});

  @override
  State<NewBudgetView> createState() => _BudgetNewViewState();
}

class _BudgetNewViewState extends State<NewBudgetView> {
  late TextEditingController _budgetNameController;

  late String _iconName;
  late int _limit;
  late DatetimeRangeModel? _rangeDatetimeModel;
  late BudgetTypeEnum _budgetType;
  late List<BudgetTypeEnum> _valuesBudgetPicker;
  late bool _showLimitField;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _budgetNameController = TextEditingController();
    _limit = 0;
    _valuesBudgetPicker = [BudgetTypeEnum.income, BudgetTypeEnum.expense];
    _budgetType = BudgetTypeEnum.income;
    _rangeDatetimeModel = null;
    _showLimitField = false;
    super.initState();
  }

  void _updateLimitFieldVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showLimitField =
            _rangeDatetimeModel?.rangeDateTimeType != RangeDateTimeEnum.allTime;
        if (!_showLimitField) {
          _limit = 0;
        }
      });
    });
  }

  void _addNewBudget(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      ref.read(newBudgetControllerProvider).addBudget(context,
          budgetName: _budgetNameController.text,
          rangeDatetimeModel: _rangeDatetimeModel!,
          iconName: _iconName,
          limit: _limit,
          budgetType: _budgetType);
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
            prefixIcon: IconManager.budget,
            validator: (p0) => p0.validateNotNull(context),
          ),
          gapH16,
          BFormPickerIcon(
            label: context.loc.budget,
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
          gapH24,
          BFormBudgetType(
            values: _valuesBudgetPicker,
            onChanged: (v) {
              setState(() {
                _budgetType = v!;
              });
            },
            initialValue: _budgetType,
            validator: (value) {
              if (value == null) {
                return context.loc.budgetTypeIsNotEmpty;
              }
              return null;
            },
          ),
          gapH24,
          BBottomsheetRangeDatetime(
              initialValue: null,
              onChanged: (e) {
                _rangeDatetimeModel = e;
                _updateLimitFieldVisibility();
              }),
          gapH16,
          if (_showLimitField)
            BFormFieldAmount(
              label: context.loc.limit,
              onChanged: (e) {
                if (e != null) {
                  _limit = e;
                }
              },
            ),
          const SizedBox(height: 64),
          Consumer(
            builder: (context, ref, child) {
              return FilledButton(
                  onPressed: () => _addNewBudget(ref),
                  child: BText(context.loc.add, color: ColorManager.white));
            },
          )
        ],
      ),
    );
  }
}
