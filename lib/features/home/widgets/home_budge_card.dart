import 'package:budget_app/common/widget/b_progress_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

enum _TypeHomeBudgeCard { safe, warning, danger }

class HomeBudgeCard extends StatelessWidget {
  HomeBudgeCard({super.key, required this.model}) {
    if (model.currentAmount <= model.limit / 2) {
      __typeHomeBudgeCard = _TypeHomeBudgeCard.safe;
    } else if (model.currentAmount < model.limit) {
      __typeHomeBudgeCard = _TypeHomeBudgeCard.warning;
    } else {
      __typeHomeBudgeCard = _TypeHomeBudgeCard.danger;
    }
  }
  final BudgetModel model;

  late final _TypeHomeBudgeCard __typeHomeBudgeCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: ColorManager.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: ColorManager.grey2),
                    child: Icon(
                      Icons.home,
                      color: ColorManager.black,
                    )),
                gapW8,
                Expanded(
                  child:
                      BText(model.name, fontWeight: FontWeightManager.semiBold),
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
    );
  }

  List<Widget> _showStatusType() {
    switch (__typeHomeBudgeCard) {
      case _TypeHomeBudgeCard.safe:
        return baseStatus(
            linearGradient: ColorManager.linearGreen,
            textStatus: 'Left',
            iconColor: ColorManager.green1,
            textColor: ColorManager.black,
            iconData: IconConstants.emojiSmile);
      case _TypeHomeBudgeCard.warning:
        return baseStatus(
            linearGradient: ColorManager.linearWarning,
            textStatus: 'Limit approaced',
            iconColor: ColorManager.orange,
            textColor: ColorManager.orange,
            iconData: IconConstants.emojiSurprise);
      case _TypeHomeBudgeCard.danger:
        return baseStatus(
            linearGradient: ColorManager.linearDanger,
            textStatus: 'Limit is exceeded',
            iconColor: ColorManager.red,
            textColor: ColorManager.red,
            iconData: IconConstants.emojiFrown);
    }
  }

  List<Widget> baseStatus(
      {required LinearGradient linearGradient,
      required String textStatus,
      required Color iconColor,
      required textColor,
      required IconData iconData}) {
    int left = model.limit - model.currentAmount;
    int progress = model.currentAmount <= model.limit
        ? (model.currentAmount / model.limit * 100).round()
        : 100;
    return [
      Row(
        children: [
          Expanded(
            child: BTextRichSpace(
              text1: '\$${model.currentAmount}/',
              text2: '\$${model.limit}',
              styleText2: BTextStyle.bodyMedium(
                  fontWeight: FontWeightManager.semiBold,
                  color: ColorManager.black),
            ),
          ),
          gapW16,
          Row(
            children: [
              BTextRichSpace(
                text1: '$textStatus:',
                text2: '\$$left',
                styleText2: BTextStyle.bodyMedium(
                    color: textColor, fontWeight: FontWeightManager.semiBold),
              ),
              gapW8,
              Icon(iconData, color: iconColor)
            ],
          )
        ],
      ),
      gapH8,
      BProgressBar(
          percent: progress,
          gradient: linearGradient,
          backgroundColor: ColorManager.grey2)
    ];
  }
}
