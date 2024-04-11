import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/apis/random_id.dart';
import 'package:budget_app/core/failure.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final budgetTransactionApiProvider = Provider(((ref) {
  final db = ref.watch(dbProvider);
  final user = ref.watch(userProvider);
  return BudgetTransactionApi(db: db, user: user);
}));

abstract class IBudgetTransactionApi {
  Future<BudgetTransactionModel> fetch();
  FutureEitherVoid add({required BudgetTransactionModel budgetTransaction});
}

class BudgetTransactionApi extends IBudgetTransactionApi {
  final FirebaseFirestore _db;
  final UserModel user;
  BudgetTransactionApi({required FirebaseFirestore db, required this.user})
      : _db = db;
  @override
  FutureEitherVoid add(
      {required BudgetTransactionModel budgetTransaction}) async {
    try {
      await _db
          .collection(FirestorePath.budgetTransactions(uid: user.id))
          .doc(RandomId.time)
          .set(budgetTransaction.toMap());
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<BudgetTransactionModel> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }
}
