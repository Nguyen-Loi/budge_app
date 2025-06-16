import 'package:package_info_plus/package_info_plus.dart';

extension PackageInfoExtensions on PackageInfo {
  String get toChatData{
    return 'App name: $appName Version: $version, Build Number: $buildNumber, Package Name: $packageName';
  }
}