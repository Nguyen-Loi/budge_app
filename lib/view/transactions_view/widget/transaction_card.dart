

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key,required this.model});
  final TransactionCardModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: BIcon(id: model.iconId),
        title: BText(model.transactionName, fontWeight: FontWeight.bold),
        subtitle: BText.b3(model.transaction.transactionDate.toFormatDate()),
        trailing: BText(
          model.transaction.amount.toMoneyStr(),
          color: model.transaction.transactionType == TransactionType.increase
              ? ColorManager.green2
              : ColorManager.red1,
        ),
      ),
    );
  }
}
