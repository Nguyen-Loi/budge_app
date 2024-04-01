import 'package:budget_app/apis/db_api.dart';
import 'package:budget_app/common/table_constant.dart';
import 'package:budget_app/models/user_model.dart';

abstract class IUserApi {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
}

class UserApi implements IUserApi {
  static const String _tableUser = TableConstant.user;
  DbApi _db = DbApi(firestore: firestore, storage: storage);
  @override
  Future<UserModel> getProfile() {
    
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
