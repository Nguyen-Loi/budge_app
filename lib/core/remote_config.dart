import 'dart:io';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RemoteConfig {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final String _requiredMinimumVersion = 'requiredMinimumVersion';
  final String _recommendedMinimumVersion = 'recommendedMinimumVersion';

  Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    String defaulValueConfig = '1.0.0';

    // Set configuration
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // These will be used before the values are fetched from Firebase Remote Config.
    await remoteConfig.setDefaults({
      _requiredMinimumVersion: defaulValueConfig,
      _recommendedMinimumVersion: defaulValueConfig,
    });

    // Fetch the values from Firebase Remote Config
    await remoteConfig.fetchAndActivate();

    // Optional: listen for and activate changes to the Firebase Remote Config values
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  Future<void> checkVersionUpdate(BuildContext context,
      {required PackageInfo packageInfo}) async {
    try {
      final appVerion = _getExtendedVersionNumber(packageInfo.version);

      final requiredMinVersion =
          _getExtendedVersionNumber(getRequiredMinimumVersion());
      final recommendedMinVersion =
          _getExtendedVersionNumber(getRecommendedMinimumVersion());

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

  String getRequiredMinimumVersion() =>
      remoteConfig.getString(_requiredMinimumVersion);

  String getRecommendedMinimumVersion() =>
      remoteConfig.getString(_recommendedMinimumVersion);

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
