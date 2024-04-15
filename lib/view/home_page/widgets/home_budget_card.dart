import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/custom/budget_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class HomeBudgetCard extends StatelessWidget {
  const HomeBudgetCard({super.key, required this.model});
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
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: ColorManager.grey3),
                      child: BIcon(id: model.iconId)),
                  gapW8,
                  Expanded(
                    child: BText(model.name,
                        fontWeight: FontWeightManager.semiBold),
                  ),
                  gapW8,
                  Icon(
                    IconConstants.arrowNext,
                    color: ColorManager.black,
                  )
                ],
              ),
              gapH8,
              ..._showStatusType()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _showStatusType() {
    switch (model.status) {
      case StatusBudgetProgress.start:
      case StatusBudgetProgress.progress:
        return baseStatus(
            textStatus: 'Left',
            iconColor: ColorManager.green1,
            textColor: ColorManager.black,
            iconData: IconConstants.emojiSmile);
      case StatusBudgetProgress.almostDone:
        return baseStatus(
            textStatus: 'Approaced',
            iconColor: ColorManager.orange,
            textColor: ColorManager.orange,
            iconData: IconConstants.emojiSurprise);
      case StatusBudgetProgress.complete:
        return baseStatus(
            textStatus: 'Exceeded',
            iconColor: ColorManager.red,
            textColor: ColorManager.red,
            iconData: IconConstants.emojiFrown);
    }
  }

  List<Widget> baseStatus(
      {required String textStatus,
      required Color iconColor,
      required textColor,
      required IconData iconData}) {
    int left = model.limit - model.currentAmount;
    return [
      Row(
        children: [
          Expanded(
            child: BTextRichSpace(
              text1: model.currentAmount.toMoneyStr(),
              text2: '/${model.limit.toMoneyStr()}',
              styleText1: BTextStyle.bodySmall(color: ColorManager.black),
              styleText2: BTextStyle.bodySmall(
                  fontWeight: FontWeightManager.bold,
                  color: ColorManager.black),
            ),
          ),
          gapW16,
          Row(
            children: [
              BTextRichSpace(
                text1: '$textStatus:',
                text2: left.toMoneyStr(),
                styleText1: BTextStyle.caption(),
                styleText2: BTextStyle.bodyMedium(
                    color: textColor, fontWeight: FontWeightManager.semiBold),
              ),
              gapW8,
              Icon(iconData, color: iconColor, size: 14)
            ],
          )
        ],
      ),
      gapH8,
      BudgetStatus(budget: model),
    ];
  }
}
