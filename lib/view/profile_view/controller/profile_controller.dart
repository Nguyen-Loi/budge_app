import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider = Provider((ref) {
  final userApi = ref.watch(userApiProvider);
  return ProfileController(userApi: userApi);
});

final loadUserControllerProvider =FutureProvider.family((ref, String uid)async {
  final profileController = ref.watch(profileControllerProvider);
  return profileController.loadUser(uid);
});

final currentUserProvider = Provider((ref) {
  final profileController = ref.watch(profileControllerProvider);
  return profileController.currentUser;
});

final uidProvider = Provider((ref) {
  final profileController = ref.watch(profileControllerProvider);
  return profileController.uid;
});

final class ProfileController extends StateNotifier<bool> {
  final UserApi _userApi;
  ProfileController({required UserApi userApi})
      : _userApi = userApi,
        super(false);
  late UserModel _currentUser;
  late String _uid;

  UserModel get currentUser => _currentUser;
  String get uid => _uid;

  Future<void> loadUser(String uid) async {
    UserModel data = await _userApi.getUserById(uid);
    _currentUser = data;
    _uid = data.id;
  }
}
