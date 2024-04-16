import 'package:budget_app/apis/get_id.dart';
import 'package:budget_app/apis/statistical_api.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/models/statistical_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statisticalControllerProvider =
    StateNotifierProvider<StatisticalController, StatisticalModel?>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final statisticalApi = ref.watch(statisticalApiProvider);
  return StatisticalController(uid: uid, statisticalApi: statisticalApi);
});

final statisticalFetchProvider = FutureProvider((ref) {
  return ref.watch(statisticalControllerProvider.notifier).fetch();
});

class StatisticalController extends StateNotifier<StatisticalModel?> {
  final String _uid;
  final StatisticalApi _statisticalApi;

  StatisticalController(
      {required String uid, required StatisticalApi statisticalApi})
      : _uid = uid,
        _statisticalApi = statisticalApi,
        super(null);

  Future<void> fetch() async {
    final data = await _statisticalApi.fetchCurrentStatistical(uid: _uid);

    if (data != null) {
      state = data;
      return;
    }
    final dataDefault = StatisticalModel(
        id: GetId.currentMonth,
        userId: _uid,
        income: 0,
        expense: 0,
        createdDate: DateTime.now(),
        updateDate: DateTime.now());
    state = dataDefault;
  }

  Future<void> updateStatistical(
      {required TransactionModel transaction}) async {
    final res = await _statisticalApi.updateStatistical(
        statistical: state!, transaction: transaction);
    res.fold((l) {}, (rData) {
      state = rData;
    });
  }
}
