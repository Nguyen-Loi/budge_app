import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

final budgetLocalProvider = Provider((ref) {
  final db = ref.watch(dbHelperProvider.notifier).db;
  return BudgetLocal(db: db);
});

class BudgetLocal implements BudgetRepository {
  BudgetLocal({required Database db}) : _db = db;
  final Database _db;

  @override
  Future<List<BudgetModel>> fetch(String uid) async {
    final result = await _db.query(
      TableName.budget,
    );
    return result.map((e) => BudgetModel.fromMap(e)).toList();
  }

  @override
  FutureEitherVoid addBudget({required BudgetModel model}) async {
    try {
      await _db.insert(
        TableName.budget,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEitherVoid updateBudget({required BudgetModel model}) async {
    try {
      await _db.update(
        TableName.budget,
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      );
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEitherVoid saveAll({
    required List<BudgetModel> budgets,
  }) async {
    if (budgets.isEmpty) {
      await _db.delete(TableName.budget);
      return right(null);
    }
    try {
      await _db.transaction((txn) async {
        await txn.delete(TableName.budget);
        final batch = txn.batch();
        for (var budget in budgets) {
          batch.insert(
            TableName.budget,
            budget.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit(noResult: true);
      });
      return right(null);
    } catch (e, _) {
      return left(Failure(error: e.toString()));
    }
  }
}
