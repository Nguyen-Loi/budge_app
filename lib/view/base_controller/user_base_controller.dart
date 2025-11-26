import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/data/services/in_app_rating_service.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBaseControllerProvider =
    NotifierProvider<UserBaseController, UserModel>(UserBaseController.new);

final userFutureProvider = FutureProvider((ref) {
  final loadUser = ref.watch(userBaseControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

class UserBaseController extends Notifier<UserModel> {
  late UserRepository _userRepository;
  late String _uid;

  @override
  UserModel build() {
    _uid = ref.watch(uidControllerProvider);

    _userRepository = ref.watch(userRepositoryProvider);
    final loc = ref.read(appLocalizationsProvider);
    return UserModel.defaultData(_uid).copyWith(name: loc.userNameDefault);
  }

  Future<UserModel> fetchUserInfo() async {
    UserModel currentUser = await _userRepository.getUserById(_uid);
    reload(currentUser);

    return currentUser;
  }

  bool get isLogin => ref.read(authApiProvider).isLogin;

  void reload(UserModel user) {
    state = user;
  }

  Future<void> updateUser(UserModel user) async {
    await _userRepository.update(user: user);
    reload(user);
  }

  /// Update user currency preference
  void updateCurrency(BuildContext context,
      {required CurrencyType newCurrency}) async {
    final currentUser = state;
    if (newCurrency == currentUser.currency) {
      return;
    }

    final updatedUser = currentUser.copyWith(
      currencyTypeValue: newCurrency.code,
      updatedDate: DateTime.now(),
    );

    // Update in database
    final res = await _userRepository.update(user: updatedUser);
    res.fold(
      (failure) {
        showSnackBarError(context, failure.message);
      },
      (user) {
        reload(user);
      },
    );
  }

  void updateWallet(BuildContext context, {required int newValue}) async {
    final closeLoading = showLoading(context: context);
    final res = await ref
        .read(transactionRepositoryProvider)
        .updateWallet(user: state, newValue: newValue, note: '');
    closeLoading();

    res.fold((l) {
      showSnackBarError(context, l.message);
    }, (r) {
      reload(r.$1);
      ref.read(transactionsBaseControllerProvider.notifier).addState(r.$2);
      _trackTransactionForReview(context);
      Navigator.pop(context);
    });
  }

  void addTransaction(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    final closeDialog = showLoading(context: context);
    final currentBudget = ref
        .read(budgetBaseControllerProvider)
        .firstWhere((e) => e.id == budgetId);

    final res = await ref
        .read(transactionRepositoryProvider)
        .addBudgetTransaction(
            user: state,
            budgetModel: currentBudget,
            amount: amount,
            note: note,
            transactionDate: transactionDate);

    res.fold((l) {
      showSnackBarError(context, l.message);
    }, (r) {
      reload(r.$3);
      ref.read(transactionsBaseControllerProvider.notifier).addState(r.$1);
      ref.read(budgetBaseControllerProvider.notifier).updateState(r.$2);
      _trackTransactionForReview(context);

      Navigator.of(context).pop();
    });

    closeDialog();
  }

  void _trackTransactionForReview(BuildContext context) async {
    try {
      final sharedUtility = ref.read(sharedUtilityProvider);
      final inAppRatingService = ref.read(inAppRatingServiceProvider);

      await sharedUtility.incrementUserTransactionCount();
      final currentTransactionCount = sharedUtility.getUserTransactionCount();

      await inAppRatingService.requestReviewIfNeeded(
        userTransactionCount: currentTransactionCount,
      );
    } catch (e, stackTrace) {
      logError('Error tracking transaction for review: $e',
          error: e, stackTrace: stackTrace);
    }
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
    final res = await _userRepository.update(user: newUser);
    res.fold((l) {
      showSnackBarError(context, l.message);
    }, (r) {
      reload(r);
    });
  }
}
