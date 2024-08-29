import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/custom/budget_expense_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/controller/budget_detail_controller.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/budget_transacitons_detail_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailView extends StatelessWidget {
  const BudgetDetailView({super.key, required this.budget});
  final BudgetModel budget;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: budget.name,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutePath.budgetModify,
                  arguments: budget);
            },
            icon: Icon(IconManager.modify, size: 16))
      ],
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView(
        children: [
          _status(context),
          gapH24,
          BudgetDetailTransactions(budget.id),
        ],
      ),
    );
  }

  Widget _status(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      BudgetModel model = ref.watch(budgetDetailControllerProvider(budget));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // info
          Row(
            children: [
              BText.b3(context.loc.youAlreadySpent),
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
                  color: Theme.of(context).colorScheme.secondary),
              gapW16,
              Expanded(
                  child: BText.h2(model.limit.toMoneyStr(),
                      textAlign: TextAlign.end)),
            ],
          ),
          gapH16,
          // Status
          BudgetExpenseStatus(budget: model),
          gapH8,
          // Content
          BText.b3(context.loc.expenseGood),
          gapH16,
          BText(
            '${context.loc.operatingPeriod}: ${model.startDate.toFormatDate(strFormat: 'dd/MM/yyyy')} - ${model.endDate.toFormatDate(strFormat: 'dd/MM/yyyy')}',
          ),
        ],
      );
    });
  }
}
