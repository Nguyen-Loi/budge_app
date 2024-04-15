import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final budgetAPIProvider = Provider((ref) {
  return BudgetApi(db: ref.watch(dbProvider));
});

abstract class IBudgetApi {
  Future<List<BudgetModel>> fetchBudgets(String uid);
  Future<List<BudgetModel>> fetchGoals(String uid);
  FutureEitherVoid addBudget({required BudgetModel model});
  Future<void> updateBudget(
      {required String budgetId, required BudgetModel model});
}

class BudgetApi implements IBudgetApi {
  final FirebaseFirestore db;
  BudgetApi({
    required this.db,
  });

  @override
  Future<List<BudgetModel>> fetchBudgets(String uid) async {
    final data = await db
        .collection(FirestorePath.budgets(uid: uid))
        .where('budgetTypeValue', isEqualTo: BudgetTypeEnum.budget.value)
        .mapModel<BudgetModel>(
            modelFrom: BudgetModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }


   @override
  Future<List<BudgetModel>> fetchGoals(String uid) async {
    final data = await db
        .collection(FirestorePath.budgets(uid: uid))
        .where('budgetTypeValue', isEqualTo: BudgetTypeEnum.goal.value)
        .mapModel<BudgetModel>(
            modelFrom: BudgetModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  FutureEitherVoid addBudget({required BudgetModel model}) async {
    try {
      await db
          .collection(FirestorePath.budgets(uid: model.userId))
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
        .collection(FirestorePath.budgets(uid: model.userId))
        .doc(budgetId)
        .update(model.toMap());
  }
}
