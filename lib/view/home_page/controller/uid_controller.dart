import 'package:flutter_riverpod/flutter_riverpod.dart';

final uidControllerProvider =
    StateNotifierProvider<UidController, String>((ref) {
  return UidController();
});

class UidController extends StateNotifier<String> {
  UidController() : super('');

  void setUid(String uid) {
    state = uid;
  }
  
  /// Clear all provider watch this uid
  void clear() {
    state = '';
  }
}
