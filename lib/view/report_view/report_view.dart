import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_money.dart';
import 'package:budget_app/common/widget/chart_budget.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/report_view/components/report_filter_view.dart';
import 'package:budget_app/view/report_view/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportView extends ConsumerStatefulWidget {
  const ReportView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(reportControllerProvider.notifier).chartBudgetList;
    return BaseView(
      title: context.loc.report,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _filterDateAndExportExcel(
                    ref: ref, context: context, list: list),
                gapH16,
                list.isNotEmpty
                    ? _body(context: context, ref: ref)
                    : const BStatus.empty(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body({required BuildContext context, required WidgetRef ref}) {
    bool isOnlyIncomeOrExpense = ref
        .watch(reportControllerProvider)
        .transactionTypes
        .isOnlyContainIncomeOrExpense;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isOnlyIncomeOrExpense
              ? ChartBudget(
                  list: ref
                      .watch(reportControllerProvider.notifier)
                      .chartBudgetList)
              : BText.b1(context.loc.reasonChartNotVisible),
        ),
        gapH16,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ColumnWithSpacing(
            children: ref
                .watch(reportControllerProvider.notifier)
                .budgetTransantionsList
                .map((e) => _cardBudget(context, budgetTransactions: e))
                .toList(),
          ),
        ),
        gapH16,
      ],
    );
  }

  PageRouteBuilder<dynamic> _animationPageFilter({required WidgetRef ref}) {
    final controller = ref.read(reportControllerProvider.notifier);
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return ReportFilterView(
          init: ref.watch(reportControllerProvider),
          values: controller.reportFilterValues,
          onChanged: (model) {
            controller.setDataFilter(model);
          },
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  Widget _filterDateAndExportExcel(
      {required WidgetRef ref,
      required BuildContext context,
      required List<ChartBudgetModel> list}) {
    final user = ref.watch(userBaseControllerProvider);
    bool disableButton = list.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          //Filter date
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  _animationPageFilter(ref: ref),
                );
              },
              child: BText.b1(context.loc.filter),
            ),
          ),
          gapW24,
          Expanded(
              child: GestureDetector(
            onTap: () {
              if (!disableButton) {
                ref
                    .read(reportControllerProvider.notifier)
                    .exportExcel(context, user: user!);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                    width: 0.5),
              ),
              child: Column(
                children: [
                  Icon(IconManager.excel,
                      color: disableButton
                          ? Theme.of(context).disabledColor
                          : null),
                  gapH8,
                  BText(context.loc.exportExcel,
                      color: disableButton
                          ? Theme.of(context).disabledColor
                          : null)
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _cardBudget(BuildContext context,
      {required BudgetTransactionsModel budgetTransactions}) {
    final budget = budgetTransactions.budget;
    final transactions = budgetTransactions.transactions;
    return ExpansionTile(
        leading: BIcon(id: budget.iconId),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2), width: 1),
        ),
        title: BText(budget.name, fontWeight: FontWeight.w700),
        trailing: BTextMoney(
          budget.currentAmount,
          fontWeight: FontWeight.bold,
        ),
        children: transactions.map((e) {
          return ListTile(
            title: BText(
              e.transactionDate.toFormatDate(),
            ),
            trailing: BTextMoney(
              e.amount,
            ),
          );
        }).toList());
  }
}
