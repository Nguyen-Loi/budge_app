import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/custom/budget_expense_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.model});
  final BudgetModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutePath.budgetDetail, arguments: model);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  BIcon(id: model.iconId),
                  gapW8,
                  Expanded(
                    child: BText(model.name, fontWeight: FontWeight.w700),
                  ),
                  gapW8,
                  Icon(
                    IconManager.arrowNext,
                    color: ColorManager.black,
                  )
                ],
              ),
              gapH8,
              ..._itemType(context)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _itemType(BuildContext context) {
    switch (model.budgetType) {
      case BudgetTypeEnum.income:
        return _itemIncome(context);
      case BudgetTypeEnum.expense:
        return _itemExpense(context);
    }
  }

  List<Widget> _itemIncome(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BText('${context.loc.startDate}: ${model.startDate.toFormatDate()}'),
          gapH8,
          BText.b1(
            model.currentAmount.toMoneyStr(isPrefix: true),
            color: Theme.of(context).colorScheme.tertiary,
          )
        ],
      )
    ];
  }

  List<Widget> _itemExpense(BuildContext context) {
    switch (model.status) {
      case StatusBudgetProgress.start:
      case StatusBudgetProgress.progress:
        return baseStatus(context,
            textStatus: context.loc.left,
            iconColor: Theme.of(context).colorScheme.tertiary,
            textColor: ColorManager.black,
            iconData: IconManager.emojiSmile);
      case StatusBudgetProgress.almostDone:
        return baseStatus(context,
            textStatus: context.loc.approaced,
            iconColor: ColorManager.orange,
            textColor: ColorManager.orange,
            iconData: IconManager.emojiSurprise);
      case StatusBudgetProgress.complete:
        return baseStatus(context,
            textStatus: context.loc.exceeded,
            iconColor: ColorManager.red1,
            textColor: ColorManager.red1,
            iconData: IconManager.emojiFrown);
    }
  }

  List<Widget> baseStatus(BuildContext context,
      {required String textStatus,
      required Color iconColor,
      required textColor,
      required IconData iconData}) {
    int left = model.limit + model.currentAmount;
    return [
      Row(
        children: [
          Expanded(
              child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: model.currentAmount.abs().toMoneyStr(),
                    style: context.textTheme.bodySmall!),
                TextSpan(
                    text: '/${model.limit.toMoneyStr()}',
                    style: context.textTheme.bodySmall!),
              ],
            ),
          )),
          gapW16,
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '$textStatus:',
                        style: context.textTheme.labelLarge!),
                    TextSpan(
                        text: left.toMoneyStr(),
                        style: context.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              gapW8,
              Icon(iconData, color: iconColor, size: 14)
            ],
          )
        ],
      ),
      gapH8,
      BudgetExpenseStatus(budget: model),
    ];
  }
}
