import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.model});
  final TransactionCardModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          _showInfo(context);
        },
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

  Future<void> _showInfo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BIcon(id: model.iconId),
                gapW16,
                BText.b1(model.transactionName, fontWeight: FontWeight.bold)
              ],
            ),
            content: ColumnWithSpacing(
              mainAxisSize: MainAxisSize.min,
              children: [
                _itemText(
                    label: context.loc.note,
                    content: model.transaction.note.isEmpty
                        ? context.loc.noData
                        : model.transaction.note),
                _itemAmount(
                    label: context.loc.amount,
                    amount: model.transaction.amount,
                    transactionType: model.transaction.transactionType),
                _itemText(
                    label: context.loc.transactionDate,
                    content: model.transaction.transactionDate.toFormatDate()),
                _itemText(
                  label: context.loc.createdDate,
                  content: model.transaction.createdDate.toFormatDate(),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: BText(
                      context.loc.close,
                      color: ColorManager.white,
                    )),
              )
            ],
          );
        });
  }

  Widget _itemText({required String label, required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BText('$label: '),
        gapH8,
        Expanded(
          child: BText(
            content,
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }

  Widget _itemAmount(
      {required String label,
      required int amount,
      required TransactionType transactionType}) {
    String amountStr;
    Color color;
    switch (transactionType) {
      case TransactionType.increase:
        amountStr = '+${amount.toMoneyStr()}';
        color = ColorManager.green2;
        break;
      case TransactionType.decrease:
        amountStr = '-${amount.toMoneyStr()}';
        color = ColorManager.red2;
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BText('$label: '),
        gapH8,
        Expanded(
          child: BText(
            amountStr,
            color: color,
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}
