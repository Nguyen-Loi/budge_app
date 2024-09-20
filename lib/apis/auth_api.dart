import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/devices/devices.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authApiProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final db = ref.watch(dbProvider);
  return AuthAPI(auth: auth, db: db, ref: ref);
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
  final ProviderRef<Object?> _ref;
  AuthAPI({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
    required ProviderRef<Object?> ref,
  })  : _auth = auth,
        _ref = ref,
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
    final DateTime now = DateTime.now();
    String email = user.email ?? 'member@gmail.com';
    final newUser = UserModel(
      id: user.uid,
      email: email,
      balance: 0,
      profileUrl: user.photoURL ??
          'https://static.vecteezy.com/system/resources/previews/023/220/595/non_2x/3d-robot-illustration-kawaii-friendly-suitable-for-tech-mascot-free-png.png',
      name: user.displayName ?? email.split('@')[0],
      accountTypeValue: accountType.value,
      currencyTypeValue: CurrencyType.vnd.value,
      createdDate: now,
      updatedDate: now,
    );
    // Write user
    await _db.doc(FirestorePath.user(user.uid)).set(newUser.toMap());

    // Write current device
    Devices device = Devices();
    final currentDevice = await device.infoDevice();
    await _db
        .doc(FirestorePath.devices(uid: user.uid))
        .set(currentDevice.toMap());
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
        return left(Failure(
            error: _ref.read(appLocalizationsProvider).passwordTooWeak));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure(
            error: _ref.read(appLocalizationsProvider).emailAlreadyExits));
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
      return left(Failure(
        error: e.message.toString(),
        message: _ref.read(appLocalizationsProvider).invalidEmailOrPassword,
      ));
    }
  }

  @override
  FutureEitherVoid loginWithFacebook() async {
    String defaultError =
        _ref.read(appLocalizationsProvider).errorSignInFacebook;
    try {
      // This code ios not working
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      await _auth.signInWithCredential(facebookCredential);
      await _writeNewInfoToDB(accountType: AccountType.facebook);
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }

  @override
  FutureEitherVoid loginWithGoogle() async {
    String defaultError = _ref.read(appLocalizationsProvider).errorSignInGoogle;
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
        return left(Failure(
            error: _ref.read(appLocalizationsProvider).accountAlreadyExits,
            message: _ref.read(appLocalizationsProvider).accountAlreadyExits));
      } else if (e.code == 'invalid-credential') {
        return left(
          Failure(
            error: _ref.read(appLocalizationsProvider).errorCredentials,
            message: _ref.read(appLocalizationsProvider).errorCredentials,
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
