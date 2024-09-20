import 'package:budget_app/core/enums/device_type_enum.dart';
import 'package:budget_app/models/device_model/android_device_model.dart';
import 'package:budget_app/models/device_model/device_model.dart';
import 'package:budget_app/models/device_model/ios_device_model.dart';
import 'package:budget_app/models/device_model/web_device_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Devices {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<DeviceModel> infoDevice() async {
    final now = DateTime.now();
    try {
      if (kIsWeb) {
        var webInfo = await deviceInfoPlugin.webBrowserInfo;
        final webModel = WebDeviceModel(
            browserName: webInfo.browserName.name,
            userAgent: webInfo.userAgent);
        return DeviceModel(
            deviceName: 'Web Browser',
            operatingSystem: DeviceTypeEnum.web.value,
            isPhysicalDevice: false,
            data: webModel.toMap(),
            createdDate: now,
            updatedDate: now);
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            var androidInfo = await deviceInfoPlugin.androidInfo;
            final androidModel = AndroidDeviceModel(
                brand: androidInfo.brand,
                model: androidInfo.model,
                sdkVersion: androidInfo.version.sdkInt);
            return DeviceModel(
                deviceName: androidInfo.model,
                operatingSystem: DeviceTypeEnum.android.value,
                isPhysicalDevice: true,
                data: androidModel.toMap(),
                createdDate: now,
                updatedDate: now);
          case TargetPlatform.iOS:
            var iosInfo = await deviceInfoPlugin.iosInfo;
            final iosModel = IosDeviceModel(
                systemName: iosInfo.systemName,
                identifierForVendor: iosInfo.identifierForVendor);
            return DeviceModel(
                deviceName: iosInfo.name,
                operatingSystem: DeviceTypeEnum.ios.value,
                isPhysicalDevice: true,
                data: iosModel.toMap(),
                createdDate: now,
                updatedDate: now);
          default:
            throw 'Unsupported platform';
        }
      }
    } on PlatformException {
      throw 'Failed to get platform version';
    }
  }
}
