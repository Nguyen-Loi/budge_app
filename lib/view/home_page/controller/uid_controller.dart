import 'package:budget_app/apis/auth_api.dart';
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

  /// Clear all provider watch this uid
  void clear() {
    state = '';
  }
}
