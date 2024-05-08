import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/async/b_async_list.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/status_widget_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/home_page/widgets/home_transactions_recently/controller/transactions_recently_controller.dart';
import 'package:budget_app/view/transactions_view/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTransactionsRecently extends ConsumerWidget {
  const HomeTransactionsRecently({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(transactionsRecentlyFutureProvider).when(
        data: (items) {
          return _base(statusWidget: StatusWidgetEnum.data, list: items);
        },
        error: (_, __) => _base(statusWidget: StatusWidgetEnum.error),
        loading: () => _base(statusWidget: StatusWidgetEnum.loading));
  }

  Widget _base(
      {List<TransactionCardModel>? list,
      required StatusWidgetEnum statusWidget}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BText('Giao dịch gần đây'),
            TextButton(
                onPressed: () {},
                child: BText(
                  'Xen tất cả',
                  color: ColorManager.green2,
                ))
          ],
        ),
        gapH16,
        switch (statusWidget) {
          StatusWidgetEnum.error =>
            const BText('Error when load transaction recently'),
          StatusWidgetEnum.loading =>
            const Text('Loading transaction recently'),
          StatusWidgetEnum.data => ColumnWithSpacing(
              children: list!
                  .map((e) => TransactionCard(model: e))
                  .toList(),
            ),
        }
      ],
    );
  }
}
