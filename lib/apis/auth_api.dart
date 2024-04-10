import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/failure.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authApiProvider = Provider((ref) {
  final account = ref.watch(authProvider);
  final db = ref.watch(dbProvider);
  return AuthAPI(auth: account, db: db);
});

abstract class IAuthApi {
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
  User? currentUserAccount();
  FutureEitherVoid signOut();
}

class AuthAPI implements IAuthApi {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  AuthAPI({required FirebaseAuth auth, required FirebaseFirestore db})
      : _auth = auth,
        _db = db;

  @override
  User currentUserAccount() {
    return _auth.currentUser!;
  }

  Future<void> _writeInfoToDB({required AccountType accountType}) {
    User user = currentUserAccount();
    return _db.doc(FirestorePath.user(user.uid)).customSet({
      'id': user.uid,
      'email': user.email,
      'name': user.displayName ?? 'User',
      'accountType': accountType.value,
      'profileUrl': user.photoURL ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSItlIyMon238HFkvhWIJidKnw2lEVhtmB3sEuBdOMr5A&s',
      'currencyType': CurrencyType.vnd
    });
  }

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _writeInfoToDB(accountType: AccountType.emailAndPassword);
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
  FutureEitherVoid signOut() async {
    try {
      await _auth.signOut();
      return right(null);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEither<User> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(currentUserAccount());
    } on FirebaseAuthException catch (e) {
      return left(Failure(error: e.code));
    }
  }

  @override
  FutureEither<User> loginWithFacebook(
      {required String email, required String password}) async {
    await _writeInfoToDB(accountType: AccountType.facebook);
    throw UnimplementedError();
  }

  @override
  FutureEither<User> loginWithGoogle(
      {required String email, required String password}) async {
    await _writeInfoToDB(accountType: AccountType.facebook);
    throw UnimplementedError();
  }
}
