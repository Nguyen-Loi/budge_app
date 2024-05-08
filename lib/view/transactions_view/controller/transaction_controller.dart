import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, List<TransactionCardModel>>(
        (ref) {
  final uid = ref.watch(uidControllerProvider).toString();
  final transactionApi = ref.watch(transactionApiProvider);
  return TransactionsController(transactionApi: transactionApi, uid: uid);
});

final transactionsFutureProvider = FutureProvider((ref) {
  final controller = ref.watch(transactionsControllerProvider.notifier);
  return controller.fetchAll();
});

class TransactionsController extends StateNotifier<List<TransactionCardModel>> {
  TransactionsController({
    required TransactionApi transactionApi,
    required String uid,
  })  : _transactionApi = transactionApi,
        _uid = uid,
        super([]);
  final TransactionApi _transactionApi;
  final String _uid;
  List<TransactionCardModel> _allCardTranctions = [];
  DateTime firstDateTransactions = DateTime.now();
  DateTime lastDateTransactions = DateTime.now();

  DateTime _dateTimePicker = DateTime.now();
  DateTime get dateTimePicker => _dateTimePicker;

  late int _sumIncome;
  late int _sumExpense;
  int get sumIncome => _sumIncome;
  int get sumExpense => _sumExpense;

  void updateDate(DateTime date) {
    _dateTimePicker = date;
    state = _allCardTranctions
        .filterByMonth(
            time: _dateTimePicker,
            getDate: (x) => x.transaction.transactionDate)
        .toList();
        _caculator();
  }

  void _caculator() {
    int newIncome = 0;
    int newExpense = 0;
    for (var e in state) {
      switch (e.transaction.transactionType) {
        case TransactionType.increase:
          newIncome += e.transaction.amount;
          break;
        case TransactionType.decrease:
          newExpense += e.transaction.amount;
          break;
      }
    }
    _sumIncome = newIncome;
    _sumExpense = newExpense;
  }

  Future<List<TransactionCardModel>> fetchAll() async {
    final transactions = await _transactionApi.fetchTransaction(_uid);
    _allCardTranctions = await TransactionCardModel.transactionCard(
        transactions: transactions, uid: _uid);
    _allCardTranctions.sort((a, b) =>
        b.transaction.transactionDate.compareTo(a.transaction.transactionDate));

    firstDateTransactions = _allCardTranctions[_allCardTranctions.length - 1]
        .transaction
        .transactionDate;
    lastDateTransactions = _allCardTranctions[0].transaction.transactionDate;

    state = _allCardTranctions
        .filterByMonth(
            time: _dateTimePicker,
            getDate: (x) => x.transaction.transactionDate)
        .toList();
    _caculator();
    return state;
  }
}
