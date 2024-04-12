import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePath {
  static const String _budget = 'Budget';
  static const String _budgetTransaction = 'BudgetTransaction';
  static const String _goal = 'Goal';
  static const String _goalTransaction = 'GoalTransaction';
  static const String _user = 'User';

  static String users() => _user;
  static String user(String uid) => '$_user/$uid';

  static String budgets({required String uid}) => '$_user/$uid/$_budget';
  static String budget({required String uid, required String budgetId}) =>
      '$_user/$uid/$_budget/$budgetId';
  static String budgetTransactions({required String uid}) =>
      '$_user/$uid/$_budgetTransaction';

  static String goals({required String uid}) => '$user/$uid/$_goal';
  static String goal({required String uid, required String goalId}) =>
      '$_user/$uid/$_goal/$goalId';
  static String goalTransactions({required String uid}) =>
      '$_user/$uid/$_goal/$_goalTransaction';
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
    int now = DateTime.now().microsecondsSinceEpoch;
    return set({'createdDate': now, 'updatedDate': now, ...data});
  }

  Future<void> customUpdate(Map<String, dynamic> data) {
    int now = DateTime.now().microsecondsSinceEpoch;
    return set({'updatedDate': now, ...data});
  }
}
