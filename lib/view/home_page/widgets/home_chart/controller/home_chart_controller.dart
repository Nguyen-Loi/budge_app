import 'package:budget_app/core/b_datetime_range.dart';
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
        allTransactionCard: _listTransactionCard,
        dateRange: BDateTimeRange.week(DateTime.now()));
  }
  final List<TransactionCardModel> _listTransactionCard;
}
