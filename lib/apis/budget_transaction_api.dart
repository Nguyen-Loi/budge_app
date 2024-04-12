import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/failure.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final budgetTransactionApiProvider = Provider(((ref) {
  final db = ref.watch(dbProvider);
  return BudgetTransactionApi(db: db);
}));

abstract class IBudgetTransactionApi {
  Future<List<BudgetTransactionModel>> fetch(String uid);
  Future<List<BudgetTransactionModel>> getBudgetTransactionsById(
      {required String uid, required String budgetId});
  FutureEitherVoid add(String uid,
      {required BudgetTransactionModel budgetTransaction});
}

class BudgetTransactionApi extends IBudgetTransactionApi {
  final FirebaseFirestore _db;
  BudgetTransactionApi({required FirebaseFirestore db}) : _db = db;
  @override
  FutureEitherVoid add(String uid,
      {required BudgetTransactionModel budgetTransaction}) async {
    try {
      await _db
          .collection(FirestorePath.budgetTransactions(uid: uid))
          .doc(budgetTransaction.id)
          .customSet(budgetTransaction.toMap());
      return right(null);
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<List<BudgetTransactionModel>> fetch(String uid) async {
    final data = await _db
        .collection(FirestorePath.budgetTransactions(uid: uid))
        .mapModel<BudgetTransactionModel>(
            modelFrom: BudgetTransactionModel.fromMap,
            modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  Future<List<BudgetTransactionModel>> getBudgetTransactionsById(
      {required String uid, required String budgetId}) async {
    final data = await _db
        .collection(FirestorePath.budgetTransactions(uid: uid))
        .where('budgetId', isEqualTo: budgetId)
        .mapModel<BudgetTransactionModel>(
            modelFrom: BudgetTransactionModel.fromMap,
            modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()!).toList();
  }
}
