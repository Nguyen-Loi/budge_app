import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePath {
  static const String _budget = 'Budgets';
  static const String _transaction = 'Transactions';
  static const String _user = 'Users';
  static const String _devices = 'Devices';
  static const String _chats = 'Chats';

  static String users() => _user;
  static String user(String uid) => '$_user/$uid';

  static String budgets({required String uid}) => '$_user/$uid/$_budget';
  static String budget({required String uid, required String budgetId}) =>
      '$_user/$uid/$_budget/$budgetId';
  static String transactions({required String uid}) =>
      '$_user/$uid/$_transaction';

  static String devices({required String uid}) => '$_user/$uid/$_devices';
  static String chats({required String uid}) => '$_user/$uid/$_chats';
}

extension Converter<T> on CollectionReference<Map<String, dynamic>> {
  Query<V> mapModel<V>(
      {required V Function(Map<String, dynamic> value) modelFrom,
      required Map<String, dynamic> Function(V model) modelTo}) {
    return withConverter<V>(
        fromFirestore: (snapshot, _) {
          return modelFrom(snapshot.data()!);
        },
        toFirestore: (model, _) => modelTo(model));
  }
}

extension ConverterDocument<T> on DocumentReference<Map<String, dynamic>> {
  DocumentReference<V> mapModel<V>(
      {required V Function(Map<String, dynamic> value) modelFrom,
      required Map<String, dynamic> Function(V model) modelTo}) {
    return withConverter<V>(
        fromFirestore: (snapshot, _) {
          return modelFrom(snapshot.data()!);
        },
        toFirestore: (model, _) => modelTo(model));
  }
}

extension ConverterQuery<T> on Query<Map<String, dynamic>> {
  Query<V> mapModel<V>(
      {required V Function(Map<String, dynamic> value) modelFrom,
      required Map<String, dynamic> Function(V model) modelTo}) {
    return withConverter<V>(
        fromFirestore: (snapshot, _) {
          return modelFrom(snapshot.data()!);
        },
        toFirestore: (model, _) => modelTo(model));
  }
}

extension ChangeData on DocumentReference<Map<String, dynamic>> {
  Future<void> customSet(Map<String, dynamic> data) {
    int now = DateTime.now().millisecondsSinceEpoch;
    return set({'createdDate': now, 'updatedDate': now, ...data});
  }

  Future<void> customUpdate(Map<String, dynamic> data) {
    int now = DateTime.now().millisecondsSinceEpoch;
    return set({'updatedDate': now, ...data});
  }
}
