import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:budget_app/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetAPIProvider = Provider((ref) {
  return BudgetApi(db: ref.watch(dbProvider));
});

abstract class IBudgetApi {
  Future<List<BudgetModel>> fetchBudgets();
  Future<void> addBudget(
      {required String name,
      required int iconId,
      required int limit,
      required DateTime startDate,
      required DateTime endDate});
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
  Future<void> addBudget(
      {required String name,
      required int iconId,
      required int limit,
      required DateTime startDate,
      required DateTime endDate}) async {
    Map<String, dynamic> data = {
      'name': name,
      'iconId': iconId,
      'limit': limit,
      'startDate': startDate,
      'endDate': endDate
    };
    await db.collection(FirestorePath.budgets(uid: uid)).add(data);
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
