import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqlite_api.dart';

final userLocalProvider = Provider((ref) {
  final db = ref.watch(sqlHelperProvider);
  return UserLocal(db: db,);
});

class UserLocal extends UserRepository {
  final Database? _db;
  UserLocal({
    required Database? db,
  })  : _db = db;

  @override
  Future<UserModel> getUserById(String uid) async {
    if (_db == null) {
     return UserModel.defaultData(uid);
    }
    try {
      final result = await _db.query(
        TableName.user,
        where: 'id = ?',
        whereArgs: [uid],
      );

      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      } else {
        UserModel userDefault = UserModel.defaultData(uid);
        await _db.insert(
          TableName.user,
          userDefault.toMap(isSqliteFomat: true),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return userDefault;
      }
    } catch (e) {
      logError('Error fetching user: $e');
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  FutureEither<UserModel> updateUser({
    required UserModel user,
  }) async {
    try {
    
      await _db?.update(
        TableName.user,
        user.toMap(isSqliteFomat: true),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      return right(user);
    } catch (e) {
      return left(Failure(message: 'Error updating user', error: e.toString()));
    }
  }

  @override
  FutureEitherVoid add({required UserModel user}) async {
    try {
      await _db?.insert(
        TableName.user,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
