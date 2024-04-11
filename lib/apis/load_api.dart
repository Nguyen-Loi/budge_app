import 'package:budget_app/view/profile_view/controller/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ILoadApi {
  Future<void> loadStartupData();
}

class LoadApi extends ILoadApi {
  final FirebaseAuth _auth;
  final ProfileController pro

  @override
  Future<void> loadStartupData() {
    _auth.currentUser!.uid;
  }
}
