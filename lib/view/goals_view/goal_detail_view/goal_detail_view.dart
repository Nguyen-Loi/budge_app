import 'dart:js';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/b_text_span.dart';
import 'package:budget_app/common/widget/custom/goal_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/budget_transacitons_detail_transactions.dart';
import 'package:budget_app/view/goals_view/goal_detail_view/controller/goal_detail_controller.dart';
import 'package:budget_app/view/goals_view/goal_detail_view/goal_detail_transactions/controller/goal_detail_transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalDetailView extends StatelessWidget {
  const GoalDetailView({Key? key, required this.goal}) : super(key: key);
  final BudgetModel goal;
  @override
  Widget build(BuildContext context) {
    return BaseView.customBackground(
      title: goal.name,
      buildTop: _buildTop(context),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutePath.goalModify,
                  arguments: goal);
            },
            icon: Icon(IconConstants.modify, size: 16))
      ],
      child: _body(context),
    );
  }

  Widget _buildTop(BuildContext context) {
    Color textColor = ColorManager.white;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText.h1(context.loc.monthlyExpense, color: ColorManager.white),
          gapH16,
          Consumer(builder: (_, res, __) {
            TransactionModel? lastestTransaction =
                res.watch(goalDetailTransactionsControllerProvider);

            return lastestTransaction == null
                ? BText(
                    context.loc.noTransactionThisBudget,
                    color: textColor,
                  )
                : BTextRich(BTextSpan(children: [
                    BTextSpan(
                        text: context.loc.nYouSpentForThePast(0),
                        style: BTextStyle.bodyMedium(color: textColor)),
                    BTextSpan(
                        text: lastestTransaction.amount.toMoneyStr(),
                        style: BTextStyle.bodyMedium(
                            color: textColor,
                            backgroundColor: ColorManager.purple22,
                            fontWeight: FontWeightManager.semiBold)),
                    BTextSpan(
                        text:
                            '${context.loc.nYouSpentForThePast(0)} ${lastestTransaction.createdDate.toTimeAgo()}',
                        style: BTextStyle.bodyMedium(color: textColor))
                  ]));
          }),
          gapH16
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      children: [
        _status(context),
        gapH24,
        BudgetDetailTransactions(goal.id),
      ],
    );
  }

  Widget _status(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      BudgetModel model = ref.watch(goalDetailControllerProvider(goal));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // info
          Row(
            children: [
              BText.b3(context.loc.youAlreadySpent, color: ColorManager.grey),
              gapW16,
              Expanded(
                  child: BText.b3(context.loc.spendLimitPerMonth,
                      textAlign: TextAlign.end)),
            ],
          ),
          gapH8,
          //number
          Row(
            children: [
              BText.h2(model.currentAmount.toMoneyStr(),
                  color: ColorManager.blue),
              gapW16,
              Expanded(
                  child: BText.h2('\$${model.limit.toMoneyStr()}',
                      textAlign: TextAlign.end)),
            ],
          ),
          gapH16,
          // Status
          GoalStatus(goal: model, showText: false),
          gapH8,
          // Content
          BText.b3(context.loc.expenseGood)
        ],
      );
    });
  }
}
