import 'dart:io';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BFileStorage {
  BFileStorage._();

  static Future<String> getExternalDocumentPath(
      {bool requestWrite = false}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      bool hasPermission = await requestWriteStoragePermission();
      if (!hasPermission) {
        throw UnsupportedError(
            "Permission denied. Please allow storage permission.");
      }
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    logInfo("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<bool> requestWriteStoragePermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      List<Permission> permissions = [];

      if (androidInfo.version.sdkInt >= 33) {
        permissions.addAll([
          Permission.videos,
          Permission.photos,
        ]);
      } else {
        permissions.add(Permission.storage);
      }

      // Request permissions
      Map<Permission, PermissionStatus> statuses = await permissions.request();

      // Check if all required permissions are granted
      bool allGranted = true;
      for (Permission permission in permissions) {
        if (statuses[permission] != PermissionStatus.granted) {
          allGranted = false;
          break;
        }
      }

      return allGranted;
    }
    if (Platform.isIOS) {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
    return false;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(List<int> bytes, String fileName) async {
    final path = await _localPath;
    File file = File('$path/$fileName');
    return file.writeAsBytes(bytes);
  }

  static openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      String strError = "Failed to open file: ${result.message}";
      return left(Failure(message: strError, error: strError));
    }
    return right(null);
  }
}
