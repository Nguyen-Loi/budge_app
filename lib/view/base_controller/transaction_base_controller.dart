import 'package:budget_app/common/log.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final transactionsBaseControllerProvider = StateNotifierProvider<
    TransactionsBaseController, List<TransactionCardModel>>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  final loc = ref.watch(appLocalizationsProvider);
  return TransactionsBaseController(
      transactionRepository: transactionRepository,
      uid: uid,
      budgetController: budgetController,
      loc: loc);
});

class TransactionsBaseController
    extends StateNotifier<List<TransactionCardModel>> {
  TransactionsBaseController({
    required TransactionRepository transactionRepository,
    required BudgetBaseController budgetController,
    required AppLocalizations loc,
    required String uid,
  })  : _transactionRepository = transactionRepository,
        _uid = uid,
        _budgetController = budgetController,
        _loc = loc,
        super([]) {
    if (uid.isNotEmpty) {
      fetch();
    }
  }
  final TransactionRepository _transactionRepository;
  final BudgetBaseController _budgetController;
  final String _uid;
  final AppLocalizations _loc;

  List<TransactionCardModel> _allCardTranctions = [];

  Future<List<TransactionCardModel>> fetch() async {
    final transactions = await _transactionRepository.fetchTransaction(_uid);
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
