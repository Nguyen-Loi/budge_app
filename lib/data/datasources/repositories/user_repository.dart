
import 'dart:io';

import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  if (kIsWeb) {
    return ref.watch(userApiProvider);
  } else {
    return ref.watch(userLocalProvider);
  }
});
abstract class UserRepository {
  Future<UserModel> getUserById(String uid);
  FutureEither<UserModel> updateUser(
      {required UserModel user, required File? file});
  FutureEitherVoid add({required UserModel user});
}