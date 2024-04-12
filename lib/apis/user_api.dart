import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return UserApi(db: db);
});

abstract class IUserApi {
  Future<UserModel> getUserById(String uid);
}

class UserApi extends IUserApi {
  final FirebaseFirestore db;
  UserApi({
    required this.db,
  });

  @override
  Future<UserModel> getUserById(String uid) async {
    final data = await db
        .doc(FirestorePath.user(uid))
        .mapModel<UserModel>(
            modelFrom: UserModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    UserModel newData = data.data()!;
    return newData;
  }
}
