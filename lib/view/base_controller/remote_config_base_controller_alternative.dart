import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/remote_config_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Alternative approach: Don't depend on user model in provider creation
final remoteConfigBaseControllerProvider =
    StateNotifierProvider<RemoteConfigBaseController, RemoteConfigModel>((ref) {
  return RemoteConfigBaseController();
});

class RemoteConfigBaseController extends StateNotifier<RemoteConfigModel> {
  static RemoteConfigModel? _cachedConfig;

  RemoteConfigBaseController()
      : super(_cachedConfig ?? RemoteConfigModel.empty());

  final remoteConfig = FirebaseRemoteConfig.instance;
  StreamSubscription<RemoteConfigUpdate>? _configUpdateSubscription;

  // Get isRoleUserAds dynamically when needed instead of storing it
  bool isUserAds(bool isRoleUserAds) =>
      state.isAds && !kIsWeb && isRoleUserAds == true;

  @override
  void dispose() {
    _configUpdateSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize(BuildContext context,
      {required PackageInfo packageInfo}) async {
    // If already initialized and we have cached config, skip reinitializing
    if (_cachedConfig != null && _cachedConfig!.isAds != false) {
      logInfo('Using cached remote config data');
      state = _cachedConfig!;
      return;
    }

    final remoteConfig = FirebaseRemoteConfig.instance;

    final minimumFetchIntervalMinutes = 10;

    // Set configuration
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration(minutes: minimumFetchIntervalMinutes),
      ),
    );

    // Set default values (useful if app is offline on first launch)
    await remoteConfig.setDefaults(state.toMap());

    await remoteConfig.activate();

    final newConfig =
        RemoteConfigModel.fromMapRemoteConfig(remoteConfig.getAll());
    state = newConfig;
    _cachedConfig = newConfig; // Cache the config

    unawaited(remoteConfig.fetch());

    if (!kIsWeb) {
      _configUpdateSubscription = remoteConfig.onConfigUpdated.listen((event) {
        log('Remote Config updated keys: ${event.updatedKeys}');
        if (!context.mounted) return;
        _handleConfigUpdate(context, packageInfo, event);
      });
    }
  }

  /// Handle real-time config updates
  Future<void> _handleConfigUpdate(BuildContext context,
      PackageInfo packageInfo, RemoteConfigUpdate event) async {
    try {
      // Activate the new config values
      await remoteConfig.activate();

      // Update the state with new values
      final newState =
          RemoteConfigModel.fromMapRemoteConfig(remoteConfig.getAll());
      state = newState;
      _cachedConfig = newState; // Update cache

      // Check if version-related keys were updated
      final versionKeys = [
        'requiredMinimumVersion',
        'recommendedMinimumVersion'
      ];
      final hasVersionUpdate =
          event.updatedKeys.any((key) => versionKeys.contains(key));

      if (hasVersionUpdate && context.mounted) {
        logInfo('Version-related config updated, checking for version update');
        await checkVersionUpdate(context, packageInfo: packageInfo);
      }
    } catch (e) {
      logError('Error handling remote config update: $e');
    }
  }

  /// Manually trigger a fetch and check for updates
  /// Useful for pull-to-refresh or when user manually checks for updates
  Future<void> manualRefresh(
      BuildContext context, PackageInfo packageInfo) async {
    try {
      log('Manual refresh of remote config triggered');
      await remoteConfig.fetch();
      await remoteConfig.activate();

      // Update state
      final newState =
          RemoteConfigModel.fromMapRemoteConfig(remoteConfig.getAll());
      state = newState;
      _cachedConfig = newState; // Update cache

      if (context.mounted) {
        await checkVersionUpdate(context, packageInfo: packageInfo);
      }
    } catch (e) {
      logError('Error during manual remote config refresh: $e');
    }
  }

  Future<void> checkVersionUpdate(BuildContext context,
      {required PackageInfo packageInfo}) async {
    try {
      final appVerion = _getExtendedVersionNumber(packageInfo.version);

      final requiredMinVersion =
          _getExtendedVersionNumber(state.requiredMinimumVersion);
      final recommendedMinVersion =
          _getExtendedVersionNumber(state.recommendedMinimumVersion);

      if (appVerion < requiredMinVersion) {
        await _showUpdateVersionDialog(context, false, packageInfo);
        return;
      }
      if (appVerion < recommendedMinVersion) {
        await _showUpdateVersionDialog(context, true, packageInfo);
        return;
      }
    } catch (e) {
      logError('Error load remote config $e');
    }
  }

  int _getExtendedVersionNumber(String version) {
    List<String> versionCells = version.split('.');
    List<int> versionNumbers =
        versionCells.map((cell) => int.parse(cell)).toList();
    return versionNumbers[0] * 100000 +
        versionNumbers[1] * 1000 +
        versionNumbers[2];
  }

  Future<void> _showUpdateVersionDialog(
      BuildContext context, bool isSkippable, PackageInfo packageInfo) async {
    final baseModel = BDialogInfo(
        title: context.loc.newVersionTitle,
        message: context.loc.newVersionDescription,
        dialogInfoType: BDialogInfoType.warning);

    if (isSkippable) {
      await baseModel.presentAction(context, textSubmit: context.loc.update,
          onSubmit: () {
        _navigateToPlayStore(packageInfo);
      });
    } else {
      await baseModel.present(context, textSubmit: context.loc.update,
          onSubmit: () {
        _navigateToPlayStore(packageInfo);
      });
    }
  }

  void _navigateToPlayStore(PackageInfo packgeInfo) {
    final appId = packgeInfo.packageName;
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/vn/",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
