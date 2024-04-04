import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/view/history_view/model/budget_transaction_custom_model.dart';
import 'package:budget_app/view/history_view/widgets/history_item_tab_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryItemTabIncome extends HistoryItemTabBase {
  const HistoryItemTabIncome({super.key, required this.list});
  final List<BudgetTransactionCustomModel> list;

  @override
  Widget buildMoney(int amount) {
    return BText('+ ${amount.toMoneyStr()}', color: ColorManager.green1);
  }

  @override
  List<BudgetTransactionCustomModel> get budgetTransactions => list;
}
