
import 'dart:io';

import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserById(String uid);
  FutureEither<UserModel> updateUser(
      {required UserModel user, required File? file});
}