import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final budgetAPIProvider = Provider((ref) {
  return BudgetApi(db: ref.watch(dbProvider));
});



class BudgetApi implements BudgetRepository {
  final FirebaseFirestore db;
  BudgetApi({
    required this.db,
  });

  @override
  Future<List<BudgetModel>> fetch(String uid) async {
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
  FutureEitherVoid updateBudget({required BudgetModel model}) async {
    try {
      await db
          .doc(FirestorePath.budget(uid: model.userId, budgetId: model.id))
          .update(model.toMap());
      return right(null);
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }
}
