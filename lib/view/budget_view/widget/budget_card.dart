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
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.model, this.isPreview = false});
  final BudgetModel model;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutePath.budgetDetail, arguments: model);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      BIcon(id: model.iconId),
                      gapW8,
                      Expanded(
                        child: BText(model.name, fontWeight: FontWeight.w700),
                      ),
                      gapW8,
                      if (!isPreview)
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
          _tagItem(context)
        ],
      ),
    );
  }

  Widget _tagItem(BuildContext context) {
    if (model.budgetStatusTime == BudgetStatusTime.active) {
      return const SizedBox.shrink();
    }
    return Positioned(
        right: -8,
        top: -8,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: model.budgetStatusTime.color(context),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                SvgPicture.asset(
                  model.budgetStatusTime.svgAsset(context),
                  width: 16,
                  height: 16,
                ),
                gapW8,
                BText.caption(model.budgetStatusTime.contentLoc(context),
                    color: ColorManager.white, fontWeight: FontWeight.w700),
              ],
            )));
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
          Expanded(
            child: BText(
              '${context.loc.startDate}: ${model.startDate.toFormatDate()}',
              maxLines: 1,
            ),
          ),
          gapH8,
          BText.b1(
            model.currentAmount.toMoneyStr(isPrefix: true),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    ];
  }

  List<Widget> _itemExpense(BuildContext context) {
    double spentPercent = model.budgetLimit > 0
        ? (model.currentAmount.abs() * 100 / model.budgetLimit)
        : 0;

    final dynamicStatus = _getDynamicStatus(spentPercent);
    final colors = _getStatusColors(context, dynamicStatus);

    return baseStatus(context,
        iconColor: colors['iconColor']!,
        textColor: colors['textColor']!,
        iconData: colors['iconData']!);
  }

  StatusBudgetProgress _getDynamicStatus(double spentPercent) {
    if (spentPercent <= 25) {
      return StatusBudgetProgress.start;
    } else if (spentPercent <= 50) {
      return StatusBudgetProgress.progress;
    } else if (spentPercent < 100) {
      return StatusBudgetProgress.almostDone;
    } else {
      return StatusBudgetProgress.complete;
    }
  }

  Map<String, dynamic> _getStatusColors(
      BuildContext context, StatusBudgetProgress status) {
    switch (status) {
      case StatusBudgetProgress.start:
        return {
          'iconColor': const Color(0xFF29B6F6), // Light blue
          'textColor': const Color(0xFF1976D2), // Dark blue
          'iconData': IconManager.emojiSmile,
        };
      case StatusBudgetProgress.progress:
        return {
          'iconColor': const Color(0xFF4CAF50), // Green
          'textColor': const Color(0xFF2E7D32), // Dark green
          'iconData': IconManager.emojiSmile,
        };
      case StatusBudgetProgress.almostDone:
        return {
          'iconColor': const Color(0xFFFF9800), // Orange
          'textColor': const Color(0xFFE65100), // Dark orange
          'iconData': IconManager.emojiSurprise,
        };
      case StatusBudgetProgress.complete:
        return {
          'iconColor': const Color(0xFFE53935), // Red
          'textColor': const Color(0xFFB71C1C), // Dark red
          'iconData': IconManager.emojiFrown,
        };
    }
  }

  List<Widget> baseStatus(BuildContext context,
      {required Color iconColor,
      required textColor,
      required IconData iconData}) {
    double spentPercent = model.budgetLimit > 0
        ? (model.currentAmount.abs() * 100 / model.budgetLimit)
        : 0;
    String leftPercent = spentPercent.toInt().toString();
    return [
      Row(
        children: [
          Expanded(
              child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: model.currentAmount.abs().toMoneyNoSymbolStr(),
                    style: context.textTheme.bodySmall!),
                TextSpan(
                    text: '/ ${model.budgetLimit.toMoneyStr()}',
                    style: context.textTheme.bodySmall!),
              ],
            ),
          )),
          gapW16,
          Row(
            children: [
              BText.caption(
                context.loc.pSpent(leftPercent),
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
