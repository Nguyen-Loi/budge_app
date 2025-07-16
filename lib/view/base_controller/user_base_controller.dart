import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/datasources/transfer_data_source.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/data/services/in_app_rating_service.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBaseControllerProvider =
    StateNotifierProvider<UserBaseController, UserModel>((ref) {
  return UserBaseController(
      uid: ref.watch(uidControllerProvider),
      ref: ref,
      userRepository: ref.watch(userRepositoryProvider),
      userApi: ref.watch(userApiProvider));
});

final userFutureProvider = FutureProvider((ref) {
  final loadUser = ref.watch(userBaseControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

class UserBaseController extends StateNotifier<UserModel> {
  final UserRepository _userRepository;
  final UserApi _userApi;
  final String _uid;
  final Ref _ref;

  UserBaseController(
      {required UserRepository userRepository,
      required Ref ref,
      required String uid,
      required UserApi userApi})
      : _userRepository = userRepository,
        _ref = ref,
        _uid = uid,
        _userApi = userApi,
        super(UserModel.defaultData());

  Future<String> userIdOrSessionId() async {
    String userId = state.id;
    if (userId.isNotEmpty) {
      return userId;
    }

    String sessionUserId =
        await _ref.read(sharedUtilityProvider).getSessionId();
    return sessionUserId;
  }

  Future<UserModel> fetchUserInfo() async {
    UserModel currentUser = await _userRepository.getUserById(_uid);
    reload(currentUser);

    return currentUser;
  }

  bool get isLogin => !GenId.isSessionId(state.id);

  void reload(UserModel user) {
    state = user;
  }

  Future<void> updateUser(UserModel user, {bool withDb = false}) async {
    await _userRepository.updateUser(user: user, file: null);
    if (withDb && !kIsWeb) {
      _updaterInDb(user);
    }
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
    final res = await _userRepository.updateUser(user: updatedUser, file: null);
    res.fold(
      (failure) {
        showSnackBarError(context, failure.message);
      },
      (user) {
        reload(user);
        _updaterInDb(user);
      },
    );
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
    final currentBudget = _ref
        .read(budgetBaseControllerProvider)
        .firstWhere((e) => e.id == budgetId);

    final res = await _ref
        .read(transactionRepositoryProvider)
        .addBudgetTransaction(
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
      _trackTransactionForReview(context);

      Navigator.of(context).pop();
    });

    closeDialog();
  }

  void _trackTransactionForReview(BuildContext context) async {
    try {
      final sharedUtility = _ref.read(sharedUtilityProvider);
      final inAppRatingService = _ref.read(inAppRatingServiceProvider);

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
    final res = await _userRepository.updateUser(user: newUser, file: null);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      reload(r);
    });
    _updaterInDb(newUser);
  }

  void _updaterInDb(UserModel user) {
    if (_userRepository is UserLocal && user.id.isNotEmpty) {
      _userApi.updateUser(user: user, file: null);
    }
  }

  void transferData(BuildContext context) async {
    final closeDialog = showLoading(
        context: context, text: context.loc.syncLocalToCloudLoading);
    final res = await TransferData.asyncData(_ref, context);
    closeDialog();

    res.fold((l) {
      logError(l.message);
      showBDialogInfoError(context, message: context.loc.syncLocalToCloudError);
    }, (r) {
      showBDialog(context,
          dialogInfoType: BDialogInfoType.success,
          message: context.loc.syncLocalToCloudSuccess);
    });
  }
}
