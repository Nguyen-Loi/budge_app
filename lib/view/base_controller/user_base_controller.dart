import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:budget_app/view/transactions_view/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBaseControllerProvider =
    StateNotifierProvider<UserBaseController, UserModel?>((ref) {
  return UserBaseController(
      transactionsController:
          ref.watch(transactionsBaseControllerProvider.notifier),
      uid: ref.watch(uidControllerProvider),
      ref: ref.watch(ref),
      userApi: ref.watch(userApiProvider));
});

final userFutureProvider = FutureProvider((ref) {
  final loadUser = ref.watch(userBaseControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

class UserBaseController extends StateNotifier<UserModel?> {
  final UserApi _userApi;
  final TransactionsBaseController _transactionController;
  final String _uid;
  final WidgetRef _ref;

  UserBaseController(
      {required TransactionsBaseController transactionsController,
      required UserApi userApi,
      required WidgetRef ref,
      required String uid})
      : _userApi = userApi,
        _ref = ref,
        _transactionController = transactionsController,
        _uid = uid,
        super(null);

  Future<UserModel> fetchUserInfo() async {
    UserModel data = await _userApi.getUserById(_uid);
    updateUser(data);
    return state!;
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void updateWallet(BuildContext context, {required int newValue}) async {
    final closeLoading = showLoading(context: context);
    final res =
        await _userApi.updateWallet(user: state!, newValue: newValue, note: '');
    closeLoading();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      updateUser(r.keys.first);
      _transactionController.addState(r.values.first);
      Navigator.pop(context);
    });
  }

  void addTransaction(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    final closeDialog = showLoading(context: context);

    final res = await _ref.read(transactionApiProvider).add(_uid,
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
      _ref.read(transactionsBaseControllerProvider.notifier).addState(r);
    });

    await _ref
        .read(budgetBaseControllerProvider.notifier)
        .updateAddAmountItemBudget(budgetId: budgetId, amount: amount);

    closeDialog();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
