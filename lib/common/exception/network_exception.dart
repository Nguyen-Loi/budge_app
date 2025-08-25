class NetworkException implements Exception {
  String? message;

  NetworkException({this.message}) {
    message ??= "No internet connection";
  }
}
