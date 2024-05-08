
import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsRecentlyControllerProvider =
    StateNotifierProvider<TransactionsRecentlyController, void>((ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionApi = ref.watch(transactionApiProvider);
  return TransactionsRecentlyController(
      transactionApi: transactionApi, uid: uid,);
});

final transactionsRecentlyFutureProvider =
    FutureProvider<List<TransactionCardModel>>((ref) {
  final controller = ref.watch(transactionsRecentlyControllerProvider.notifier);
  return controller.getTransactionsRecently();
});

class TransactionsRecentlyController
    extends StateNotifier<List<TransactionModel>> {
  TransactionsRecentlyController(
      {required TransactionApi transactionApi,
      required String uid,
 })
      : _transactionApi = transactionApi,
        _uid = uid,
        super([]);
  final TransactionApi _transactionApi;
  final String _uid;

  Future<List<TransactionCardModel>> getTransactionsRecently() async {
    List<TransactionModel> transactions =
        await _transactionApi.fetchTransactionsRecently(uid: _uid);
    final list = await TransactionCardModel.transactionCard(transactions: transactions, uid: _uid);
    return list;
  }


}
