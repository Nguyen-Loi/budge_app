import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserApi {
  final FirebaseFirestore db;
  UserApi({
    required this.db,
  });

  String get uid => '123';

  Future<UserModel> getUser() async {
    final data = await db
        .doc(FirestorePath.user(uid))
        .mapModel<UserModel>(
            modelFrom: UserModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    return data.data()!;
  }
}
