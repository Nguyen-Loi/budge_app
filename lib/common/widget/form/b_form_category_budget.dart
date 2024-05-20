import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class BFormCategoryBudget extends FormField<BudgetModel> {
  final Function(String budgetId) onChanged;
  BFormCategoryBudget({
    super.key,
    required String label,
    required List<BudgetModel> list,
    super.initialValue,
    required this.onChanged,
    super.validator,
  }) : super(builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BText.h2(label),
              if (field.hasError) gapH8,
              if (field.hasError)
                Text(
                  field.errorText ?? "Invalid",
                  style:
                      AppTextTheme.bodySmall.copyWith(color: ColorManager.red1),
                ),
              gapH16,
              list.isEmpty
                  ? BText(
                      field.context.loc.noBudget,
                      textAlign: TextAlign.center,
                    )
                  : _CategoryBudget(field.context,
                      list: list,
                      initialValue: field.value, onChanged: (model) {
                      field.didChange(model);
                    }),
            ],
          );
        });
  @override
  FormFieldState<BudgetModel> createState() {
    return _BFormCategoryBudgetState();
  }
}

class _BFormCategoryBudgetState extends FormFieldState<BudgetModel> {
  @override
  BFormCategoryBudget get widget => super.widget as BFormCategoryBudget;

  @override
  void didChange(BudgetModel? value) {
    if (value != null) {
      widget.onChanged(value.id);
    }
    super.didChange(value);
  }
}

class _CategoryBudget extends StatelessWidget {
  const _CategoryBudget(this.context,
      {required this.list,
      required this.initialValue,
      required this.onChanged});
  final List<BudgetModel> list;
  final BuildContext context;
  final BudgetModel? initialValue;
  final Function(BudgetModel model) onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: list.map((e) => _itemCategory(model: e)).toList(),
    );
  }

  Widget _itemCategory({required BudgetModel model}) {
    bool isSelected = initialValue != null && model.id == initialValue!.id;
    return isSelected
        ? _itemCategoryBase(
            context,
            model: model,
            backgroundColor: Theme.of(context).colorScheme.primary,
          )
        : InkWell(
            onTap: () {
              onChanged(model);
            },
            child: _itemCategoryBase(
              context,
              model: model,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          );
  }

  Widget _itemCategoryBase(
    BuildContext context, {
    required BudgetModel model,
    required Color backgroundColor,
  }) {
    return Card(
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            BIcon(id: model.iconId),
            gapH16,
            BText(
              model.name,
              fontWeight: FontWeight.bold,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
