import 'package:budget_app/core/failure.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(authProvider);
  return AuthAPI(auth: account);
});

abstract class IAuthAPI {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });
  FutureEither<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  FutureEither<User> loginWithFacebook({
    required String email,
    required String password,
  });
  FutureEither<User> loginWithGoogle({
    required String email,
    required String password,
  });
  FutureEither<User> loginWithDemo({
    required String email,
    required String password,
  });
  User? currentUserAccount();
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final FirebaseAuth _auth;
  AuthAPI({required FirebaseAuth auth}) : _auth = auth;

  @override
  User? currentUserAccount() {
    return _auth.currentUser;
  }

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(account.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(const Failure(error: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return left(
            const Failure(error: 'The account already exists for that email.'));
      }
       return left(Failure(error: e.code));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _auth.signOut();
      return right(null);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEither<User> loginWithDemo(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  FutureEither<User> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(currentUserAccount()!);
    } on FirebaseAuthException catch (e) {
      return left(Failure(error: e.code));
    }
  }

  @override
  FutureEither<User> loginWithFacebook(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  FutureEither<User> loginWithGoogle(
      {required String email, required String password}) {
    throw UnimplementedError();
  }
}
