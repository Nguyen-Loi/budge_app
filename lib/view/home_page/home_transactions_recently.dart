import 'dart:math';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
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
    return _base(list: listRecently);
  }

  Widget _base({required List<TransactionCardModel> list}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BText('Giao dịch gần đây'),
            TextButton(
                onPressed: () {},
                child: BText(
                  'Xem tất cả',
                  color: ColorManager.green2,
                ))
          ],
        ),
        gapH16,
        ...list.map((e) => TransactionCard(model: e)).toList()
      ],
    );
  }
}
