import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/custom/budget_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_detail/widget/budget_detail_transactions.dart';
import 'package:flutter/material.dart';

class BudgetDetailView extends StatelessWidget {
  const BudgetDetailView({Key? key, required this.budget}) : super(key: key);
  final BudgetModel budget;
  @override
  Widget build(BuildContext context) {
    return BaseView.customBackground(
      title: budget.name,
      buildTop: _buildTop(),
      child: _body(),
    );
  }

  Widget _buildTop() {
    Color textColor = ColorManager.white;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText.h1('Monthly Expense', color: ColorManager.white),
          gapH16,
          Row(
            children: [
              BText('You\'ve spent ', color: textColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: ColorManager.purple15,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: BText('\$60', color: textColor),
              ),
              BText(' for the past 7 days', color: textColor)
            ],
          ),
          gapH16
        ],
      ),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        _status(),
        gapH24,
        BudgetDetailTransactions(budget.id),
      ],
    );
  }

  Widget _status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // info
        Row(
          children: [
            BText.b3('You\'ve already spent', color: ColorManager.grey),
            gapW16,
            const Expanded(
                child: BText.b3('Spend limit per Month',
                    textAlign: TextAlign.end)),
          ],
        ),
        gapH8,
        //number
        Row(
          children: [
            BText.h2('60', color: ColorManager.blue),
            gapW16,
            const Expanded(child: BText.h2('\$120', textAlign: TextAlign.end)),
          ],
        ),
        gapH16,
        // Status
        BudgetStatus(budget: budget),
        gapH8,
        // Content
        const BText.b3('Cool! Let\'t keep your expense below the limit.')
      ],
    );
  }

   

 

  

}

