import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
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
          .filterByWeek(
              time: DateTime.now(),
              getDate: (e) => e.transaction.transactionDate)
          .toList(),
    );
  }
  final List<TransactionCardModel> _listTransactionCard;
}
