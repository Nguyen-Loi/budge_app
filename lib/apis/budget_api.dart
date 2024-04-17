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
  Future<List<BudgetModel>> fetchBudgetsByMonth(String uid,
      {required int month});
  Future<List<BudgetModel>> fetchGoals(String uid);
  FutureEitherVoid addBudget({required BudgetModel model});
  FutureEitherVoid updateBudget(
      {required BudgetModel model});
}

class BudgetApi implements IBudgetApi {
  final FirebaseFirestore db;
  BudgetApi({
    required this.db,
  });

  /// [month] is type millisecondsSinceEpoch. With DateTime using BDateTime.month to convert this type
  @override
  Future<List<BudgetModel>> fetchBudgetsByMonth(String uid,
      {required int month}) async {
    final data = await db
        .collection(FirestorePath.budgets(uid: uid))
        .where('budgetTypeValue', isEqualTo: BudgetTypeEnum.budget.value)
        .where('month', isEqualTo: month)
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
  FutureEitherVoid updateBudget(
      { required BudgetModel model}) async{
    try{
     await db
        .doc(FirestorePath.budget(uid: model.userId, budgetId: model.id))
        .update(model.toMap());
     return right(null);
    }catch(e){
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }
}
