import 'dart:math';

import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/transactions_view/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTransactionsRecently extends ConsumerWidget {
  const HomeTransactionsRecently({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(transactionsBaseControllerProvider);
    final listRecently = list.take(min(list.length, 5)).toList();
    return _base(context, list: listRecently);
  }

  Widget _base(BuildContext context,
      {required List<TransactionCardModel> list}) {
    return list.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText(context.loc.recentTransactions),
              gapH16,
              ColumnWithSpacing(
                  children: list.map((e) => TransactionCard(model: e)).toList())
            ],
          );
  }
}
