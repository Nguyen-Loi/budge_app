import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/view/budget_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/data/budget_data.dart';
import 'package:budget_app/features/budget_detail/budget_detail_view.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class HomeBudgeCard extends StatelessWidget {
  const HomeBudgeCard({super.key, required this.model});
  final BudgetModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BudgetDetailView(budget: BudgetData.data),
          ),
        );
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
                      child: Icon(
                        Icons.home,
                        color: ColorManager.black,
                      )),
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
      case StatusBudget.safe:
        return baseStatus(
            textStatus: 'Left',
            iconColor: ColorManager.green1,
            textColor: ColorManager.black,
            iconData: IconConstants.emojiSmile);
      case StatusBudget.warning:
        return baseStatus(
            textStatus: 'Limit approaced',
            iconColor: ColorManager.orange,
            textColor: ColorManager.orange,
            iconData: IconConstants.emojiSurprise);
      case StatusBudget.danger:
        return baseStatus(
            textStatus: 'Limit is exceeded',
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
      BudgetStatus(budget: model),
    ];
  }
}
