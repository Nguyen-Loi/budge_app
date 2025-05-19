import 'dart:io';

import 'package:budget_app/data/datasources/apis/storage_api.dart';
import 'package:budget_app/data/datasources/apis/storage_path.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqlite_api.dart';

final userLocalProvider = Provider((ref) {
  final db = ref.watch(dbHelperProvider.notifier).db;
  final storageApi = ref.watch(storageAPIProvider);
  return UserLocal(db: db, storageApi: storageApi);
});

class UserLocal extends UserRepository {
  final Database _db;
  final StorageApi _storageApi;
  UserLocal({
    required Database db,
    required StorageApi storageApi,
  })  : _db = db,
        _storageApi = storageApi;

  @override
  Future<UserModel> getUserById(String uid) async {
    try {
      final result = await _db.query(
        TableName.user,
        where: 'id = ?',
        whereArgs: [uid],
      );

      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      } else {
        UserModel userDefault = UserModel.defaultData();
        await _db.insert(
          TableName.user,
          userDefault.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return userDefault;
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  FutureEither<UserModel> updateUser({
    required UserModel user,
    required File? file,
  }) async {
    try {
      String profileUrl = user.profileUrl;

      if (file != null) {
        final res = await _storageApi.uploadFile(
          file,
          filePath: StoragePath.user(user.id),
        );
        res.fold(
          (l) => throw Exception('Error uploading file: ${l.message}'),
          (r) => profileUrl = r,
        );
      }

      final updatedUser = user.copyWith(profileUrl: profileUrl);
      await _db.update(
        TableName.user,
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );

      return right(updatedUser);
    } catch (e) {
      return left(Failure(message: 'Error updating user', error: e.toString()));
    }
  }

  @override
  FutureEitherVoid add({required UserModel user}) async {
    try {
      await _db.insert(
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
