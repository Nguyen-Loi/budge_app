import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

String downloadFile({required List<int> bytes, required String fileName}) {
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
