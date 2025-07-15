import 'dart:io';

import 'package:budget_app/core/b_file_storage.dart';
import 'package:budget_app/core/b_file_web.dart';
import 'package:flutter/foundation.dart';


class BFile {
  BFile._();

  static Future<String> download(
      {required List<int> bytes, required String fileName}) async {
    if (!kIsWeb) {
      File file = await BFileStorage.writeCounter(bytes, fileName);
      return file.path;
    }
    return BFileWeb.download(bytes: bytes, fileName: fileName);
  }
}
