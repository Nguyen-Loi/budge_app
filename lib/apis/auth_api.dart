import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/failure.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authApiProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final db = ref.watch(dbProvider);
  return AuthAPI(auth: auth, db: db);
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
  FutureEitherVoid loginWithFacebook();
  FutureEitherVoid loginWithGoogle();
  FutureEitherVoid signOut();
  bool get isLogin;
}

class AuthAPI implements IAuthApi {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  AuthAPI({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
  })  : _auth = auth,
        _db = db;
  String get uid => _auth.currentUser!.uid;

  User _currentUserAccount() {
    return _auth.currentUser!;
  }

  Future<void> _writeNewInfoToDB({required AccountType accountType}) async {
    User user = _currentUserAccount();
    if (accountType == AccountType.google ||
        accountType == AccountType.facebook) {
      final isUserExitsOnDb = await _db
          .collection(FirestorePath.users())
          .where('id', isEqualTo: user.uid)
          .limit(1)
          .get();
      if (isUserExitsOnDb.size != 0) {
        return;
      }
    }
    return _db.doc(FirestorePath.user(user.uid)).customSet({
      'id': user.uid,
      'email': user.email,
      'name': user.displayName ?? user.email!.split('@')[0],
      'accountValue': accountType.value,
      'profileUrl': user.photoURL ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSItlIyMon238HFkvhWIJidKnw2lEVhtmB3sEuBdOMr5A&s',
      'currencyValue': CurrencyType.vnd.value
    });
  }

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
    try {
      final account = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _writeNewInfoToDB(accountType: AccountType.emailAndPassword);
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _writeNewInfoToDB(accountType: AccountType.emailAndPassword);
      return right(_currentUserAccount());
    } on FirebaseAuthException catch (e) {
      return left(Failure(error: e.message.toString()));
    }
  }

  @override
  FutureEitherVoid loginWithFacebook() async {
    String defaultError = 'Error occurred using Facebook Sign-In. Try again.';
    try {
      // This code ios not working
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await _auth.signInWithCredential(facebookCredential);
      await _writeNewInfoToDB(accountType: AccountType.facebook);
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }

  @override
  FutureEitherVoid loginWithGoogle() async {
    String defaultError = 'Error occurred using Google Sign-In. Try again.';
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        await _writeNewInfoToDB(accountType: AccountType.google);
        return right(null);
      }
      return left(Failure(message: defaultError));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return left(const Failure(
            error: 'The account already exists.',
            message:
                'The account already exists with a different credential.'));
      } else if (e.code == 'invalid-credential') {
        return left(
          const Failure(
            error: 'Error occurred while accessing credentials.',
            message: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
      return left(Failure(message: defaultError, error: e.toString()));
    } catch (e) {
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }

  @override
  bool get isLogin => _auth.currentUser != null;
}
