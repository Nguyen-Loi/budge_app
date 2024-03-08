import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class HomeBudgeCard extends StatelessWidget {
  const HomeBudgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.home),
              gapW8,
              const Expanded(
                child: BText('Accomodation',
                    fontWeight: FontWeightManager.semiBold),
              ),
              gapW8,
              Icon(IconConstants.arrowNext)
            ],
          ),
          gapH8,
          Row(
            children: [
              Expanded(
                child: BTextRichSpace(
                  text1: '\$0/',
                  text2: '\$200',
                  styleText2: BTextStyle.bodyMedium(
                      fontWeight: FontWeightManager.semiBold),
                ),
              ),
              gapW16,
              Row(
                children: [
                  BTextRichSpace(
                    text1: 'Left:',
                    text2: '\$200',
                    styleText2: BTextStyle.bodyMedium(
                        fontWeight: FontWeightManager.semiBold),
                  ),
                  gapW8,
                  const Icon(Icons.smart_button)
                ],
              )
            ],
          ),
          const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
