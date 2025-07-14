import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/data/datasources/apis/device_api.dart';
import 'package:budget_app/data/datasources/transfer_data_source.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

final transferDataSourceProvider = Provider((ref) => TransferData);

final mainPageControllerProvider = Provider((ref) {
  return MainPageController(ref: ref);
});

final mainPageFutureProvider =
    FutureProvider.family<void, BuildContext>((ref, context) {
  final controller = ref.watch(mainPageControllerProvider);
  return controller.loadBaseDataOptimized(context);
});

class MainPageController extends StateNotifier<void> {
  final Ref _ref;

  MainPageController({required Ref ref})
      : _ref = ref,
        super(null);

  Future<void> loadBaseDataOptimized(BuildContext context) async {
    final uid = _ref.watch(uidControllerProvider);
    final isLogin = uid.isNotEmpty;

    if (!isLogin && kIsWeb) {
      logInfo('User is not logged in, redirecting to onboarding...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, RoutePath.login);
      });
      return;
    }

    if (!kIsWeb) {
      logInfo('Loading information database....');
      await _ref.read(sqlHelperProvider.notifier).initDatabase();
    }

    // Merge API and SQLite data if internet is available
    if (!kIsWeb && await _hasInternetConnection()) {
      logInfo('Merging API and SQLite data...');
      final result = await TransferData.apiToSqliteMerge(_ref);
      result.match(
        (failure) => logError('apiToSqliteMerge failed: ${failure.message}'),
        (_) => logInfo('apiToSqliteMerge completed successfully'),
      );
    } else {
      logInfo('No internet connection, skipping apiToSqliteMerge.');
    }

    logInfo('Loading critical user data...');
    await _ref.read(userBaseControllerProvider.notifier).fetchUserInfo();

    logInfo('Loading budget and transaction data with lazy loading...');
    final budgetFuture = Future.microtask(
        () => _ref.read(budgetBaseControllerProvider.notifier).fetch());
    final transactionFuture = Future.microtask(
        () => _ref.read(transactionsBaseControllerProvider.notifier).fetch());
    await Future.wait([budgetFuture, transactionFuture]);

    // Check if context is still mounted before proceeding with background tasks
    if (context.mounted) {
      logInfo('Loading background tasks with optimization...');
      unawaited(_loadBackgroundTasksOptimized(context, uid, isLogin));
    }

    logInfo('Essential data loading completed with optimization');
  }

  /// Checks for internet connectivity
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadBackgroundTasksOptimized(
      [BuildContext? context, String? uid, bool? isLogin]) async {
    final currentUid = uid ?? _ref.read(uidControllerProvider);
    final currentIsLogin = isLogin ?? (currentUid?.isNotEmpty ?? false);

    final backgroundTasks = <String, Future Function()>{
      'package_info': () => context != null
          ? _loadPackageInfoAndRemoteConfig(context)
          : Future.value(),
      'ads_init': () => !kIsWeb ? _initGoogleMobileAds() : Future.value(),
      'svg_assets': () => _loadSvgAssets(),
      'user_specific': () =>
          (currentIsLogin && (currentUid?.isNotEmpty ?? false))
              ? _loadUserSpecificData(currentUid!)
              : Future.value(),
    };

    // Schedule each task in a separate microtask to distribute load
    final futures = backgroundTasks.entries.map((entry) {
      return Future.microtask(() async {
        try {
          logInfo('Starting background task: ${entry.key}');
          await entry.value();
          logInfo('Completed background task: ${entry.key}');
        } catch (e) {
          logInfo('Background task ${entry.key} failed: $e');
        }
      });
    }).toList();

    // Execute all background tasks with timeout protection
    try {
      await Future.wait(futures, eagerError: false)
          .timeout(const Duration(seconds: 30));
      logInfo('All background tasks completed');
    } catch (e) {
      logInfo('Background tasks completed with some failures: $e');
    }
  }

  Future<void> _loadPackageInfoAndRemoteConfig(BuildContext context) async {
    try {
      final refPackage = _ref.read(packageInfoBaseControllerProvider.notifier);
      logInfo('Loading package info app...');
      final packageInfo = await refPackage.init();

      if (context.mounted && !kIsWeb) {
        logInfo('Check version update ...');
        _ref
            .read(remoteConfigBaseControllerProvider.notifier)
            .initialize(context, packageInfo: packageInfo);
      }
    } catch (e) {
      logInfo('Package info/remote config loading failed: $e');
    }
  }

  /// Loads user-specific data in background
  Future<void> _loadUserSpecificData(String uid) async {
    final userTasks = <Future>[];

    // Device info writing
    userTasks
        .add(_ref.read(deviceAPIProvider).writeDeviceInfo(uid).catchError((e) {
      logInfo('Device info writing failed: $e');
    }));

    // Chat initialization
    userTasks.add(
        _ref.read(chatBaseControllerProvider.notifier).init().catchError((e) {
      logInfo('Chat initialization failed: $e');
    }));

    await Future.wait(userTasks);
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  Future<void> _loadSvgAssets() async {
    const loader = SvgAssetLoader(SvgAssets.iconBotApp);
    svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }
}
