import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/apis/get_id.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/core.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/models/statistical_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final statisticalApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return StatisticalApi(db: db);
});

abstract class IStatisticalApi {
  FutureEither<StatisticalModel> updateStatistical(
      {required StatisticalModel statistical,
      required BudgetTransactionModel budgetTransaction});
  Future<StatisticalModel?> fetchCurrentStatistical({required String uid});
}

class StatisticalApi extends IStatisticalApi {
  final FirebaseFirestore _db;
  StatisticalApi({required FirebaseFirestore db}) : _db = db;
  @override
  FutureEither<StatisticalModel> updateStatistical(
      {required StatisticalModel statistical,
      required BudgetTransactionModel budgetTransaction}) async {
    try {
      StatisticalModel newStatistical = _updateStatisticalBaseOnTransaction(
          statistical: statistical, transaction: budgetTransaction);
      await _db
          .collection(FirestorePath.statistical(uid: statistical.userId))
          .doc(newStatistical.id)
          .set(newStatistical.toMap());
      return right(newStatistical);
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  StatisticalModel _updateStatisticalBaseOnTransaction(
      {required StatisticalModel statistical,
      required BudgetTransactionModel transaction}) {
    DateTime now = DateTime.now();
    final oldIncome = statistical.income;
    final oldExpense = statistical.expense;
    final amount = transaction.amount;

    int newIncome = statistical.income;
    int newExpense = statistical.expense;
    switch (transaction.transactionType) {
      case TransactionType.income:
        newIncome = oldIncome + amount;
      case TransactionType.expense:
        newExpense = oldExpense + amount;
        newIncome = oldIncome - amount;
    }
    return statistical.copyWith(
        income: newIncome, expense: newExpense, updateDate: now);
  }

  @override
  Future<StatisticalModel?> fetchCurrentStatistical(
      {required String uid}) async {
    final document = await _db
        .collection(FirestorePath.statistical(uid: uid))
        .doc(GetId.month)
        .mapModel(
            modelFrom: StatisticalModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return document.data();
  }
}
