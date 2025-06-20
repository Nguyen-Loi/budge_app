import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uidControllerProvider =
    StateNotifierProvider<UidController, String>((ref) {
  final uid = ref.watch(authApiProvider).uid;
  return UidController(uid: uid);
});

class UidController extends StateNotifier<String> {
  UidController({required String? uid}) : super(uid ?? '');

  void init(String uid) {
    state = uid;
  }

  void clear() {
    state = '';
  }

  String get uid => state;
}
