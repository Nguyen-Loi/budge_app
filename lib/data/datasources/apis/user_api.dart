import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/utils/data_config_utils.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return UserApi(db: db);
});

class UserApi extends UserRepository {
  final FirebaseFirestore _db;
  UserApi({
    required FirebaseFirestore db,
  }) : _db = db;

  @override
  Future<UserModel> getUserById(String uid) async {
    final data = await _db
        .doc(FirestorePath.user(uid))
        .mapModel<UserModel>(
            modelFrom: UserModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    UserModel? newData = data.data();
    if (newData == null) {
      throw Exception('User not found');
    }
    return newData;
  }

  @override
  FutureEither<UserModel> updateUser({required UserModel user}) async {
    user = user.copyWith(
      updatedDate: DateTime.now(),
    );
    Map<String, dynamic> data = user.toMap();
    if (!DataConfigUtils.instance.isOnlyOnlineData) {
      data.remove('balance');
    }
    await _db.doc(FirestorePath.user(user.id)).update(data);
    return right(user);
  }

  @override
  FutureEitherVoid add({required UserModel user}) async {
    try {
      await _db.doc(FirestorePath.user(user.id)).set(user.toMap());
      return right(null);
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  FutureEitherVoid removeSession({required String sessionId}) async {
    DocumentReference<Map<String, dynamic>> docRef =
        _db.collection(FirestorePath.users()).doc(sessionId);
    final isExists = await docRef.get().then((doc) => doc.exists);
    if (isExists) {
      await docRef.delete();
      return right(null);
    } else {
      return left(Failure(error: 'Session ID does not exist'));
    }
  }
}
