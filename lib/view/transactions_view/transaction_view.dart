import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/picker/b_picker_month.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:budget_app/view/transactions_view/controller/transaction_controller.dart';
import 'package:budget_app/view/transactions_view/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _builder(),
    );
  }

  Widget _builder() {
    return Consumer(builder: (_, ref, __) {
      final currentTime =
          ref.watch(transactionControllerProvider.notifier).dateTimePicker;
      final list = ref.watch(transactionControllerProvider);
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryText(
                    ref: ref,
                    label: 'Income',
                    value: ref
                        .watch(transactionControllerProvider.notifier)
                        .sumIncome,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 16),
                  _summaryText(
                    ref: ref,
                    label: 'Expense',
                    value: ref
                        .watch(transactionControllerProvider.notifier)
                        .sumExpense,
                    color: ColorManager.red1,
                  ),
                ],
              ),
              BPickerMonth(
                  initialDate: ref
                      .watch(transactionControllerProvider.notifier)
                      .dateTimePicker,
                  firstDate: ref
                      .watch(transactionControllerProvider.notifier)
                      .firstDateTransactions,
                  lastDate: ref
                      .watch(transactionControllerProvider.notifier)
                      .lastDateTransactions,
                  onChange: (date) async {
                    if (!date.isSameDate(currentTime)) {
                      ref
                          .read(transactionControllerProvider.notifier)
                          .updateDate(date);
                    }
                  })
            ],
          ),
          gapH16,
          list.isEmpty
              ? const Expanded(child: BStatus.empty())
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(transactionControllerProvider),
                    child: ListViewWithSpacing(
                      children:
                          list.map((e) => TransactionCard(model: e)).toList(),
                    ),
                  ),
                )
        ],
      );
    });
  }

  Widget _summaryText(
      {required WidgetRef ref,
      required String label,
      required int value,
      required Color color}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: '$label: ',
        style: context.textTheme.bodyMedium!,
      ),
      TextSpan(
        text: value.toMoneyStr(),
        style: context.textTheme.bodyLarge!
            .copyWith(color: color, fontWeight: FontWeight.w700),
      )
    ]));
  }
}
