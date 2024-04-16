import 'dart:io';

import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final profileControllerProvider = Provider((ref) {
  final userApi = ref.watch(userApiProvider);
  return ProfileController(userApi: userApi);
});

final class ProfileController extends StateNotifier<UserModel?> {
  final UserApi _userApi;
  final HomeController _homeController;
  ProfileController(
      {required UserApi userApi, required HomeController homeController})
      : _userApi = userApi,
        _homeController = homeController,
        super(null);

  Future<void> updateUser ({required File? file,required String name, required String }){
    PhoneNumber d= PhoneNumber()
  }
}
