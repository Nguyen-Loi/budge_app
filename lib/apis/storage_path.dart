class StoragePath {
  static const String _budget = 'Budget';
  static const String _transaction = 'Transaction';
  static const String _user = 'User';
  static const String _statistical = 'Statistical';

  static String user(String uid) => '$_user/$uid/';
}
