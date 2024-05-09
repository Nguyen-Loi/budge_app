import 'dart:io';

import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/apis/storage_api.dart';
import 'package:budget_app/apis/storage_path.dart';
import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final storageApi = ref.watch(storageAPIProvider);
  final transactionApi = ref.watch(transactionApiProvider);
  return UserApi(
      db: db, storageApi: storageApi, transactionApi: transactionApi);
});

abstract class IUserApi {
  Future<UserModel> getUserById(String uid);
  FutureEither<UserModel> updateUser(
      {required UserModel user, required File? file});
}

class UserApi extends IUserApi {
  final FirebaseFirestore _db;
  final StorageApi _storageApi;
  final TransactionApi _transactionApi;
  UserApi({
    required FirebaseFirestore db,
    required StorageApi storageApi,
    required TransactionApi transactionApi,
  })  : _db = db,
        _transactionApi = transactionApi,
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
      return left(Failure(message: l.message, error: l.error));
    }, (r) {
      profileUrl = r;
    });
    final newUser = user.copyWith(profileUrl: profileUrl);
    await _db.doc(FirestorePath.user(user.id)).set(newUser.toMap());
    return right(newUser);
  }

  FutureEither<Map<UserModel, TransactionModel>> updateWallet(
      {required UserModel user,
      required int newValue,
      required String note}) async {
    try {
      final now = DateTime.now();

      final newUser = user.copyWith(balance: newValue, updatedDate: now);
      await _db.doc(FirestorePath.user(newUser.id)).update(newUser.toMap());

      int amountChanged = newValue - user.balance;
      final transactionType = TransactionType.fromAmount(amountChanged);

      final newTransaction = await _transactionApi.add(user.id,
          budgetId: null,
          amount: amountChanged.abs(),
          note: note,
          transactionType: transactionType);
      return right({user: newTransaction.getOrElse((l) {
        throw Exception('Error when get add transaction');
      })});
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }
}
