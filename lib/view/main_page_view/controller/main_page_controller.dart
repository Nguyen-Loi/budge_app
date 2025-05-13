import 'package:budget_app/data/datasources/apis/device_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
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
import 'package:flutter/foundation.dart';

final mainPageControllerProvider = Provider((ref) {
  return MainPageController(ref: ref);
});

final mainPageFutureProvider =
    FutureProvider.family<void, BuildContext>((ref, context) {
  final controller = ref.watch(mainPageControllerProvider);
  return controller.loadBaseData(context);
});

class MainPageController extends StateNotifier<void> {
  final Ref _ref;

  MainPageController({required Ref ref})
      : _ref = ref,
        super(null);

  Future<void> loadBaseData(BuildContext context) async {
    final uid = _ref.watch(uidControllerProvider);
    bool isLogin = uid.isNotEmpty;

    if (!kIsWeb) {
      logInfo('Loading infomation database....');
      await _ref.read(dbHelperProvider.notifier).initDatabase();
    }

    // Base data
    logInfo('Loading infomation user....');
    await _ref.read(userBaseControllerProvider.notifier).fetchUserInfo();

    // Package info
    final refPackage = _ref.read(packageInfoBaseControllerProvider.notifier);
    logInfo('Loading package info app...');
    await refPackage.init().then((e) {
      if (!context.mounted || kIsWeb) return;
      logInfo('Check version update ...');
      _ref
          .read(remoteConfigBaseControllerProvider.notifier)
          .initialize(context, packageInfo: e);
    });

    // ads
    if (!kIsWeb) {
      logInfo('Initialize Google Mobile Ads SDK');
      await _initGoogleMobileAds();
    }

    // assets svg
    _loadSvgAssets();

    logInfo('Loading infomation budget...');
    await _ref.read(budgetBaseControllerProvider.notifier).fetch();
    logInfo('Loading infomation transactions...');
    await _ref.read(transactionsBaseControllerProvider.notifier).fetch();

    if (isLogin) {
      // Write current device
      await _ref.read(deviceAPIProvider).writeDeviceInfo(uid);

      logInfo('Loading infomation chat...');
      await _ref.watch(chatBaseControllerProvider.notifier).init();
    }
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
