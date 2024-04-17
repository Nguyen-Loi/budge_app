import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/b_text_span.dart';
import 'package:budget_app/common/widget/custom/budget_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/controller/budget_detail_controller.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/budget_detail_transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          Consumer(builder: (_, res, __) {
            TransactionModel? lastestTransaction =
                res.watch(budgetDetailControllerProvider);

            return lastestTransaction == null
                ? BText(
                    'You don\'t have any transactions with this budget.',
                    color: textColor,
                  )
                : BTextRich(BTextSpan(children: [
                    BTextSpan(
                        text: 'You\'ve spent ',
                        style: BTextStyle.bodyMedium(color: textColor)),
                    BTextSpan(
                        text: ' ${lastestTransaction.amount.toMoneyStr()} ',
                        style: BTextStyle.bodyMedium(
                            color: textColor,
                            backgroundColor: ColorManager.purple22,
                            fontWeight: FontWeightManager.semiBold)),
                    BTextSpan(
                        text:
                            ' for the past ${lastestTransaction.createdDate.toTimeAgo()}',
                        style: BTextStyle.bodyMedium(color: textColor))
                  ]));
          }),
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
            BText.h2(budget.currentAmount.toMoneyStr(),
                color: ColorManager.blue),
            gapW16,
            Expanded(
                child: BText.h2('\$${budget.limit.toMoneyStr()}',
                    textAlign: TextAlign.end)),
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
