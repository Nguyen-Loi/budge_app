import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoBaseControllerProvider =
    NotifierProvider<PackageInfoBaseController, PackageInfo>(
        PackageInfoBaseController.new);

class PackageInfoBaseController extends Notifier<PackageInfo> {
  @override
  PackageInfo build() {
    return PackageInfo(
      appName: 'SmartBudget',
      packageName: 'unknown',
      version: '0.0.0',
      buildNumber: '0'
    );
  }

  bool get isInit {
    bool isDataDefault = state.version == '0.0.0';
    return !isDataDefault;
  }

  Future<PackageInfo> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    state = packageInfo;
    return state;
  }
}
