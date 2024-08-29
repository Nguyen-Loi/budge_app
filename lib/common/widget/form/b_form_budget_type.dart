import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

class BFormBudgetType extends FormField<BudgetTypeEnum> {
  BFormBudgetType(
      {super.key,
      super.initialValue,
      required List<BudgetTypeEnum> values,
      required ValueChanged<BudgetTypeEnum?> onChanged,
      super.validator})
      : super(
          builder: (field) {
            return Column(
              children: [
                RowWithSpacing(
                  children: values.map((e) {
                    bool isSelected = field.value == e;
                    return InkWell(
                      onTap: isSelected
                          ? null
                          : () {
                              field.didChange(e);
                              onChanged(e);
                            },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(field.context).colorScheme.primary
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: ColorManager.primary)),
                          child: BText(
                            e.content(field.context),
                            color: isSelected ? ColorManager.white : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (field.hasError) ...[
                  gapH8,
                  BText(
                    field.errorText ?? field.context.loc.invalid,
                    color: Theme.of(field.context).colorScheme.error,
                  )
                ]
              ],
            );
          },
        );
}
