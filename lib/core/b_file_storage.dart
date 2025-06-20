import 'dart:io';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';

class BFileStorage {
  BFileStorage._();

  /// Simple approach: Use app-specific directories that don't require permissions
  static Future<String> getExternalDocumentPath(
      {bool requestWrite = false}) async {
    Directory directory;
    if (Platform.isAndroid) {
      // Use external app directory - no permissions needed
      directory = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    logInfo("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  /// Simple file saving - no complex permissions
  static Future<File> writeCounter(List<int> bytes, String fileName) async {
    final path = await getExternalDocumentPath();
    File file = File('$path/$fileName');
    return file.writeAsBytes(bytes);
  }

  static openFile(AppLocalizations loc, String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      String strError = "Failed to open file: ${result.message}";
      if (result.type == ResultType.noAppToOpen) {
        strError = loc.noAppToOpen;
      }
      if (result.type == ResultType.fileNotFound) {
        strError = loc.pFileNotFound(filePath);
      }
      if (result.type == ResultType.permissionDenied) {
        strError = loc.permissionDenied;
      }
      return left(Failure(message: strError, error: strError));
    }
    return right(null);
  }
}
