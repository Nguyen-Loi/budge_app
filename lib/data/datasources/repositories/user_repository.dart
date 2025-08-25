import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ref.watch(userApiProvider);
});
abstract class UserRepository {
  Future<UserModel> getUserById(String uid);
  FutureEither<UserModel> updateUser(
      {required UserModel user});
  FutureEitherVoid add({required UserModel user});
}