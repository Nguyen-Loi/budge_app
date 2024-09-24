import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final transactionsBaseControllerProvider = StateNotifierProvider<
    TransactionsBaseController, List<TransactionCardModel>>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionApi = ref.watch(transactionApiProvider);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  final loc = ref.watch(appLocalizationsProvider);
  return TransactionsBaseController(
      transactionApi: transactionApi,
      uid: uid,
      budgetController: budgetController,
      loc: loc);
});

final transactionsFutureProvider = FutureProvider((ref) {
  final controller = ref.watch(transactionsBaseControllerProvider.notifier);
  return controller.fetch();
});

class TransactionsBaseController
    extends StateNotifier<List<TransactionCardModel>> {
  TransactionsBaseController({
    required TransactionApi transactionApi,
    required BudgetBaseController budgetController,
    required AppLocalizations loc,
    required String uid,
  })  : _transactionApi = transactionApi,
        _uid = uid,
        _budgetController = budgetController,
        _loc = loc,
        super([]);
  final TransactionApi _transactionApi;
  final BudgetBaseController _budgetController;
  final String _uid;
  final AppLocalizations _loc;

  List<TransactionCardModel> _allCardTranctions = [];

  Future<List<TransactionCardModel>> fetch() async {
    final transactions = await _transactionApi.fetchTransaction(_uid);
    _allCardTranctions = await TransactionCardModel.transactionCard(_loc,
        transactions: transactions, budgets: _budgetController.getAll);

    if (_allCardTranctions.isEmpty) {
      return [];
    }
    _allCardTranctions.sort((a, b) =>
        b.transaction.transactionDate.compareTo(a.transaction.transactionDate));
    state = _allCardTranctions;
    return state;
  }

  void addState(TransactionModel model) {
    _allCardTranctions.insert(
        0, model.toTransactionCard(_loc, budgets: _budgetController.getAll));
    state = _allCardTranctions.toList();
  }
}
