import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/core.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final budgetAPIProvider = Provider((ref) {
  return BudgetApi(db: ref.watch(dbProvider));
});

abstract class IBudgetApi {
  Future<List<BudgetModel>> fetchBudgets();
  FutureEitherVoid addBudget({required BudgetModel model});
  Future<void> updateBudget(
      {required String budgetId, required BudgetModel model});
}

class BudgetApi implements IBudgetApi {
  final FirebaseFirestore db;
  BudgetApi({
    required this.db,
  });

  final String uid = '123';

  @override
  Future<List<BudgetModel>> fetchBudgets() async {
    final data = await db
        .collection(FirestorePath.budgets(uid: uid))
        .mapModel<BudgetModel>(
            modelFrom: BudgetModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  FutureEitherVoid addBudget({required BudgetModel model}) async {
    try {
      await db
          .collection(FirestorePath.budgets(uid: uid))
          .doc(model.id)
          .customSet(model.toMap());
      return right(null);
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<void> updateBudget(
      {required String budgetId, required BudgetModel model}) {
    return db
        .collection(FirestorePath.budgets(uid: uid))
        .doc(budgetId)
        .update(model.toMap());
  }
}
