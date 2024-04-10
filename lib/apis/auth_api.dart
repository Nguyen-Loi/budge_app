import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
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
      'name': user.displayName ?? user.email!.split('@')[0],
      'accountType': accountType.value,
      'profileUrl': user.photoURL ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSItlIyMon238HFkvhWIJidKnw2lEVhtmB3sEuBdOMr5A&s',
      'currencyType': CurrencyType.vnd.value
    });
  }

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(currentUserAccount());
    } on FirebaseAuthException catch (e) {
      return left(Failure(error: e.message.toString()));
    }
  }

  @override
  FutureEitherVoid loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      await _writeInfoToDB(accountType: AccountType.facebook);
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString()));
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
        await FirebaseAuth.instance.signInWithCredential(credential);
        await _writeInfoToDB(accountType: AccountType.google);
        return right(null);
      }
      return left(const Failure(message: 'You have canceled your login'));
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
      logError(e.toString());
      return left(Failure(message: defaultError, error: e.toString()));
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }
}
