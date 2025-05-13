import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBaseControllerProvider =
    StateNotifierProvider<UserBaseController, UserModel>((ref) {
  return UserBaseController(
      uid: ref.watch(uidControllerProvider),
      ref: ref,
      userRepository: ref.watch(userRepositoryProvider));
});

final userFutureProvider = FutureProvider((ref) {
  final loadUser = ref.watch(userBaseControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

class UserBaseController extends StateNotifier<UserModel> {
  final UserRepository _userRepository;
  final String _uid;
  final Ref _ref;

  UserBaseController(
      {required UserRepository userRepository, required Ref ref, required String uid})
      : _userRepository = userRepository,
        _ref = ref,
        _uid = uid,
        super(UserModel.defaultData());

  Future<UserModel> fetchUserInfo() async {
    UserModel currentUser = await _userRepository.getUserById(_uid);
    String? token = await _ref.read(messagingProvider).getToken();
    currentUser = currentUser.copyWith(token: token);

    // update token profile
    await _userRepository.updateUser(user: currentUser, file: null);
    reload(currentUser);

    return state;
  }

  bool get isLogin => state.id.isNotEmpty;

  void reload(UserModel user) {
    state = user;
  }

  Future<void> updateUser(UserModel user) async {
    await _userRepository.updateUser(user: user, file: null);
    reload(user);
  }

  void updateWallet(BuildContext context, {required int newValue}) async {
    final closeLoading = showLoading(context: context);
    final res = await _ref
        .read(transactionRepositoryProvider)
        .updateWallet(user: state, newValue: newValue, note: '');
    closeLoading();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      reload(r.$1);
      _ref.read(transactionsBaseControllerProvider.notifier).addState(r.$2);
      Navigator.pop(context);
    });
  }

  void addTransaction(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    final closeDialog = showLoading(context: context);
    final currentBudget = _ref
        .read(budgetBaseControllerProvider)
        .firstWhere((e) => e.id == budgetId);

    final res = await _ref.read(transactionRepositoryProvider).addBudgetTransaction(
        user: state,
        budgetModel: currentBudget,
        amount: amount,
        note: note,
        transactionDate: transactionDate);

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      reload(r.$3);
      _ref.read(transactionsBaseControllerProvider.notifier).addState(r.$1);
      _ref.read(budgetBaseControllerProvider.notifier).updateState(r.$2);
      Navigator.of(context).pop();
    });

    closeDialog();
  }

  void toggleNotificationTransaction(
    BuildContext context, {
    required bool isOn,
  }) async {
    final currentUser = state;
    if (isOn == currentUser.isRemindTransactionEveryDate) {
      return;
    }

    final newUser = currentUser.copyWith(
        isRemindTransactionEveryDate:
            !currentUser.isRemindTransactionEveryDate);
    final res = await _userRepository.updateUser(user: newUser, file: null);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      reload(r);
    });
  }
}
