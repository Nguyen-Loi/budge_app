import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/extension/extension_query.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final transactionApiProvider = Provider(((ref) {
  final db = ref.watch(dbProvider);
  return TransactionApi(db: db);
}));

abstract class ITransactionApi {
  Future<List<TransactionModel>> fetchTransaction(String uid);
  Future<List<TransactionModel>> getTransactionsByBudgetId(
      {required String uid, required String budgetId});
  FutureEitherVoid add(String uid, {required TransactionModel transaction});
  Future<List<TransactionModel>> fetchTransactionOfMonth(
      {required String uid, required DateTime dateTime});
}

class TransactionApi extends ITransactionApi {
  final FirebaseFirestore _db;
  TransactionApi({required FirebaseFirestore db}) : _db = db;
  @override
  FutureEitherVoid add(String uid,
      {required TransactionModel transaction}) async {
    try {
      await _db
          .collection(FirestorePath.transactions(uid: uid))
          .doc(transaction.id)
          .customSet(transaction.toMap());
      return right(null);
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<List<TransactionModel>> fetchTransaction(String uid) async {
    final data = await _db
        .collection(FirestorePath.transactions(uid: uid))
        .mapModel<TransactionModel>(
            modelFrom: TransactionModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByBudgetId(
      {required String uid, required String budgetId}) async {
    final data = await _db
        .collection(FirestorePath.transactions(uid: uid))
        .where('budgetId', isEqualTo: budgetId)
        .mapModel<TransactionModel>(
            modelFrom: TransactionModel.fromMap,
            modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  Future<List<TransactionModel>> fetchTransactionOfMonth(
      {required String uid, required DateTime dateTime}) async {
    final data = await _db
        .collection(FirestorePath.transactions(uid: uid))
        .filterByMonth(time: dateTime)
        .mapModel<TransactionModel>(
            modelFrom: TransactionModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }
}
