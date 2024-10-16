import 'package:budget_app/apis/device_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/core/remote_config.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final mainPageControllerProvider = Provider((ref) {
  final userController = ref.watch(userBaseControllerProvider.notifier);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  final transactionController =
      ref.watch(transactionsBaseControllerProvider.notifier);
  return MainPageController(
      userController: userController,
      budgetController: budgetController,
      transactionController: transactionController,
      ref: ref);
});

final mainPageFutureProvider =
    FutureProvider.family<void, BuildContext>((ref, context) {
  final controller = ref.watch(mainPageControllerProvider);
  return controller.loadBaseData(context);
});

class MainPageController extends StateNotifier<void> {
  final UserBaseController _userController;
  final BudgetBaseController _budgetController;
  final TransactionsBaseController _transactionsController;
  final Ref _ref;

  MainPageController(
      {required UserBaseController userController,
      required BudgetBaseController budgetController,
      required TransactionsBaseController transactionController,
      required Ref ref})
      : _userController = userController,
        _budgetController = budgetController,
        _transactionsController = transactionController,
        _ref = ref,
        super(null);

  Future<void> loadBaseData(BuildContext context) async {
    final uid = _ref.watch(uidControllerProvider);

    // Package info
    final refPackage = _ref.read(packageInfoBaseControllerProvider.notifier);
    if (!refPackage.isInit) {
      logInfo('Loading package info app...');
      await refPackage.init().then((e) {
        logInfo('Check version update ...');
        RemoteConfig remoteConfig = RemoteConfig();
        remoteConfig.checkVersionUpdate(context, packageInfo: e);
      });

      // Write current device
      await _ref.read(deviceAPIProvider).writeDeviceInfo(uid);

      // Base data
      logInfo('Loading infomation user....');
      await _userController.fetchUserInfo();

      logInfo('Loading infomation chat...');
      await _ref.watch(chatBaseControllerProvider.notifier).init();

      // ads
      _initGoogleMobileAds();

      // assets svg
      _loadSvgAssets();
    }

    logInfo('Loading infomation budget...');
    await _budgetController.fetch();
    logInfo('Loading infomation transactions...');
    await _transactionsController.fetch();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    logInfo('Initialize Google Mobile Ads SDK');
    return MobileAds.instance.initialize();
  }

  Future<void> _loadSvgAssets() async {
    const loader = SvgAssetLoader(SvgAssets.iconBotApp);
    svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }
}
