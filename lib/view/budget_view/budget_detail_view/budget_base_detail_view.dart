import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/controller/budget_detail_controller.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/budget_transacitons_detail_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BudgetBaseDetailView extends StatelessWidget {
  const BudgetBaseDetailView({
    super.key,
    required this.budget,
    required this.transactions,
  });

  final BudgetModel budget;
  final List<TransactionModel> transactions;

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

  List<Widget> header(BuildContext context, BudgetModel budget);

  String strTime(BuildContext context, {required BudgetModel model}) {
    return '${context.loc.operatingPeriod}: ${model.startDate.toFormatDate(strFormat: 'dd/MM/yyyy')} - ${model.endDate.toFormatDate(strFormat: 'dd/MM/yyyy')}';
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView(
        children: [
          _status(context),
          gapH24,
          BudgetDetailTransactions(transactions),
        ],
      ),
    );
  }

  Widget _status(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      BudgetModel model = ref.watch(budgetDetailControllerProvider(budget));
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: header(context, model));
    });
  }
}
