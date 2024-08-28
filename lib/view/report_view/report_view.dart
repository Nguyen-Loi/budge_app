import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/chart_budget.dart';
import 'package:budget_app/common/widget/picker/b_picker_month.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/report_view/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportView extends ConsumerWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(reportControllerProvider.notifier).chartBudgetList;
    return BaseView(
      title: context.loc.report,
      child: ListView(
        children: [
          _filterDateAndExportExcel(ref: ref, context: context, list: list),
          gapH16,
          list.isNotEmpty
              ? _body(context: context, ref: ref)
              : const BStatus.empty()
        ],
      ),
    );
  }

  Widget _body({required BuildContext context, required WidgetRef ref}) {
    return Column(
      children: [
        ChartBudget(
            list: ref.watch(reportControllerProvider.notifier).chartBudgetList),
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
        )
      ],
    );
  }

  Widget _filterDateAndExportExcel(
      {required WidgetRef ref,
      required BuildContext context,
      required List<ChartBudgetModel> list}) {
    final currentTimePicker = ref.watch(reportControllerProvider);
    final user = ref.watch(userBaseControllerProvider);
    bool disableButton = list.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          //Filter date
          Expanded(
            flex: 2,
            child: BPickerMonth(
                initialDate: currentTimePicker,
                firstDate: ref
                    .watch(reportControllerProvider.notifier)
                    .datetimeRange
                    .start,
                lastDate: ref
                    .watch(reportControllerProvider.notifier)
                    .datetimeRange
                    .end,
                onChange: (date) async {
                  if (!date.isSameDate(currentTimePicker)) {
                    ref
                        .read(reportControllerProvider.notifier)
                        .updateDate(date);
                  }
                }),
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
                          : Theme.of(context).colorScheme.primary),
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
    final budgetColor = budget.budgetType == BudgetTypeEnum.income
        ? Theme.of(context).colorScheme.tertiary
        : ColorManager.red1;
    final budgetAmount = budget.budgetType == BudgetTypeEnum.income
        ? budget.currentAmount.toMoneyStr()
        : '- ${budget.currentAmount.toMoneyStr()}';
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
        trailing: BText(
          budgetAmount,
          color: budgetColor,
        ),
        children: transactions.map((e) {
          final transactionColor = e.budgetType == BudgetTypeEnum.income
              ? Theme.of(context).colorScheme.tertiary
              : ColorManager.red1;
          final transactionAmount = e.budgetType == BudgetTypeEnum.income
              ? e.amount.toMoneyStr()
              : '- ${e.amount.toMoneyStr()}';
          return ListTile(
            title: BText(
              e.transactionDate.toFormatDate(),
            ),
            trailing: BText(
              transactionAmount,
              fontStyle: FontStyle.italic,
              color: transactionColor,
            ),
          );
        }).toList());
  }
}
