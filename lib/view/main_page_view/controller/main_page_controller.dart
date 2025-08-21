import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/data/datasources/apis/device_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/view/base_controller/asset_controller.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

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
    final isAuthenicated = _ref.read(authApiProvider).isAuthenticated;
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
    await _ref.read(assetControllerProvider.notifier).load(context);
    if (!isAuthenicated) {
      await _ref.read(authApiProvider).signInAnonymously();
    }
    String? uid = _ref.read(authProvider).currentUser?.uid;
    if (uid == null) {
      throw Exception('User UID is null, cannot proceed with loading data');
    }

    // Only initialize UID if it's not already set
    Future.microtask(() {
      _ref.read(uidControllerProvider.notifier).init(uid);
    });

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
      unawaited(_loadBackgroundTasksOptimized(
          context: context, uid: uid, isLogin: isAuthenicated));
      unawaited(_refreshInfoUser(_ref));
    }

    logInfo('Essential data loading completed with optimization');
  }

  Future<void> _refreshInfoUser(Ref ref) async {
    String? token =
        await ref.read(messagingProvider).getToken().catchError((e) {
      logError('Failed to get FCM token: $e');
      return null;
    });
    final user = ref.read(userBaseControllerProvider);
    final now = DateTime.now();
    final UserRoleEnum newRole = user.subscriptionExpiryDate != null &&
            user.subscriptionExpiryDate!.isAfter(now)
        ? UserRoleEnum.premium
        : UserRoleEnum.normal;
    final updatedUser = user.copyWith(
      token: token,
      role: newRole,
    );
    if (token != null) {
      await ref.read(userBaseControllerProvider.notifier).updateUser(
            updatedUser,
          );
    }
  }

  Future<void> _loadBackgroundTasksOptimized(
      {required BuildContext context,
      required String uid,
      required bool isLogin}) async {
    final backgroundTasks = <String, Future Function()>{
      'package_info': () => _loadPackageInfoAndRemoteConfig(context),
      'ads_init': () => !kIsWeb ? _initGoogleMobileAds() : Future.value(),
      'svg_assets': () => _loadSvgAssets(),
      'user_specific': () =>
          isLogin ? _loadUserSpecificData(uid) : Future.value(),
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
      if (!context.mounted) return;
      logInfo('Check version update ...');
      _ref
          .read(remoteConfigBaseControllerProvider.notifier)
          .initialize(context, packageInfo: packageInfo);
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
