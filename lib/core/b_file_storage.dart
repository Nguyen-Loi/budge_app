import 'dart:io';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class BFileStorage {
  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus status = await Permission.storage.request();
      logInfo(status.name);
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

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(List<int> bytes, String fileName) async {
    final path = await _localPath;
    File file = File('$path/$fileName');
    return file.writeAsBytes(bytes);
  }

  static FutureEitherVoid openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      String strError = "Failed to open file: ${result.message}";
      return left(Failure(message: strError, error: strError));
    }
    return right(null);
  }
}
