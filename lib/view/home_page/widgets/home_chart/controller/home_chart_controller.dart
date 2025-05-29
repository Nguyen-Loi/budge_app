import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeChartStateControllerProvider =
    StateNotifierProvider<HomeChartController, List<ChartBudgetModel>>((ref) {
  final listTransactionCard = ref.watch(transactionsBaseControllerProvider);
  return HomeChartController(listTransactionCard: listTransactionCard);
});

class HomeChartController extends StateNotifier<List<ChartBudgetModel>> {
  HomeChartController({required List<TransactionCardModel> listTransactionCard})
      : _listTransactionCard = listTransactionCard,
        super([]) {
    // List available
    state = ChartBudgetModel.toList(
        allTransactionCard: _listTransactionCard
            .filterByMonth(
                time: DateTime.now(),
                getDate: (e) => e.transaction.transactionDate)
            .toList(),
        transactionTypes: [
          TransactionTypeEnum.expenseBudget,
          TransactionTypeEnum.expenseWallet
        ]);
  }
  final List<TransactionCardModel> _listTransactionCard;
}
