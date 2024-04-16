import 'dart:io';

import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/apis/storage_api.dart';
import 'package:budget_app/apis/storage_path.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final storageApi = ref.watch(storageAPIProvider);
  return UserApi(db: db, storageApi: storageApi);
});

abstract class IUserApi {
  Future<UserModel> getUserById(String uid);
  FutureEither<UserModel> updateUser(
      {required UserModel user, required File? file});
}

class UserApi extends IUserApi {
  final FirebaseFirestore _db;
  final StorageApi _storageApi;
  UserApi({
    required FirebaseFirestore db,
    required StorageApi storageApi,
  })  : _db = db,
        _storageApi = storageApi;

  @override
  Future<UserModel> getUserById(String uid) async {
    final data = await _db
        .doc(FirestorePath.user(uid))
        .mapModel<UserModel>(
            modelFrom: UserModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    UserModel newData = data.data()!;
    return newData;
  }

  @override
  FutureEither<UserModel> updateUser(
      {required UserModel user, required File? file}) async {
    if (file == null) {
      await _db.doc(FirestorePath.user(user.id)).set(user.toMap());
      return right(user);
    }

    String profileUrl = '';
    final res =
        await _storageApi.uploadFile(file, filePath: StoragePath.user(user.id));
    res.fold((l) {
      return left(Failure(
          message: 'An error occur when upload image', error: l.message));
    }, (r) {
      profileUrl = r;
    });
    final newUser = user.copyWith(profileUrl: profileUrl);
    await _db.doc(FirestorePath.user(user.id)).set(newUser.toMap());
    return right(newUser);
  }
}
