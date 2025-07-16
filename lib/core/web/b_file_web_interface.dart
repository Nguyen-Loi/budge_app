import 'b_file_web_stub.dart'
    if (dart.library.html) 'b_file_web_impl.dart'
    if (dart.library.io) 'b_file_web_mobile.dart';

class BFileWeb {
  BFileWeb._();

  static String download({required List<int> bytes, required String fileName}) {
    return downloadFile(bytes: bytes, fileName: fileName);
  }
}
