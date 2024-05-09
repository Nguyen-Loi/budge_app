import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsBaseControllerProvider = StateNotifierProvider<
    TransactionsBaseController, List<TransactionCardModel>>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionApi = ref.watch(transactionApiProvider);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  return TransactionsBaseController(
      transactionApi: transactionApi,
      uid: uid,
      budgetController: budgetController);
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
    required String uid,
  })  : _transactionApi = transactionApi,
        _uid = uid,
        _budgetController = budgetController,
        super([]);
  final TransactionApi _transactionApi;
  final BudgetBaseController _budgetController;
  final String _uid;

  List<TransactionCardModel> _allCardTranctions = [];

  Future<List<TransactionCardModel>> fetch() async {
    final transactions = await _transactionApi.fetchTransaction(_uid);
    _allCardTranctions = await TransactionCardModel.transactionCard(
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
    _allCardTranctions
        .insert(0,model.toTransactionCard(budgets: _budgetController.getAll));
    state = _allCardTranctions.toList();
  }

  void addTransaction(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    final closeDialog = showLoading(context: context);

    final res = await _transactionApi.add(_uid,
        budgetId: budgetId,
        amount: amount,
        note: note ?? '',
        transactionType: TransactionType.increase,
        transactionDate: transactionDate);

    res.fold((l) {
      closeDialog();
      showSnackBar(context, context.loc.anErrorUnexpectedOccur);
      return;
    }, (r) {
      addState(r);
    });

    await _budgetController.updateAddAmountItemBudget(
        budgetId: budgetId, amount: amount);

    closeDialog();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
