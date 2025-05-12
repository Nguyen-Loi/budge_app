import 'dart:io';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/remote_config_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final remoteConfigBaseControllerProvider =
    StateNotifierProvider<RemoteConfigBaseController, RemoteConfigModel>((ref) {
  UserModel? userModel = ref.watch(userBaseControllerProvider);
  return RemoteConfigBaseController(userModel: userModel);
});

class RemoteConfigBaseController extends StateNotifier<RemoteConfigModel> {
  RemoteConfigBaseController({required UserModel? userModel})
      : _userModel = userModel,
        super(RemoteConfigModel(
            geminiApiKey: '0',
            recommendedMinimumVersion: '1.0.0',
            requiredMinimumVersion: '1.0.0',
            isAds: false));
  final remoteConfig = FirebaseRemoteConfig.instance;
  final UserModel? _userModel;

  bool get isUserAds => state.isAds && !kIsWeb && _userModel?.roleAds == true;

  Future<void> initialize(BuildContext context,
      {required PackageInfo packageInfo}) async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set configuration
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // These will be used before the values are fetched from Firebase Remote Config.
    await remoteConfig.setDefaults(state.toMap());

    // Fetch the values from Firebase Remote Config
    await remoteConfig.fetchAndActivate();
    state = RemoteConfigModel.fromMapRemoteConfig(remoteConfig.getAll());

    if(!context.mounted) return;
    checkVersionUpdate(context, packageInfo: packageInfo);
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
