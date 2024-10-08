import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoBaseControllerProvider =
    StateNotifierProvider<PackageInfoBaseController, PackageInfo>((ref) {
  return PackageInfoBaseController();
});

class PackageInfoBaseController extends StateNotifier<PackageInfo> {
  PackageInfoBaseController()
      : super(PackageInfo(
            appName: 'Ví Nhỏ',
            packageName: '',
            version: '0.0.0',
            buildNumber: '0'));
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
