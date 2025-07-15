import 'package:flutter/foundation.dart';
import 'dart:js_interop' if (dart.library.io) 'dart:io';
import 'package:web/web.dart' as web if (dart.library.io) 'dart:io';

class BFileWeb {
  BFileWeb._();

  static String download({required List<int> bytes, required String fileName}) {
    if (!kIsWeb) {
      throw UnsupportedError("This method is not supported on web platform");
    }
    final uint8List = Uint8List.fromList(bytes);
    final blob = web.Blob([uint8List.toJS].toJS);
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    web.document.body?.appendChild(anchor);
    anchor.click();
    web.document.body?.removeChild(anchor);
    web.URL.revokeObjectURL(url);
    return fileName;
  }
}
