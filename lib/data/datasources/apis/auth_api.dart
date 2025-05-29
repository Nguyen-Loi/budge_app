import 'package:budget_app/common/log.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
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
  FutureEitherVoid resetPassword({
    required String email,
  });
  bool get isLogin;
}

class AuthAPI implements IAuthApi {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final Ref<Object?> _ref;
  AuthAPI({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
    required Ref<Object?> ref,
  })  : _auth = auth,
        _ref = ref,
        _db = db;
  String get uid => _auth.currentUser?.uid ?? '';

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
          'https://cdn-icons-png.flaticon.com/512/1144/1144760.png',
      name: user.displayName ?? email.split('@')[0],
      accountTypeValue: accountType.value,
      currencyTypeValue: CurrencyType.vnd.value,
      role: UserRole.normal,
      languageCode: _ref.read(languageControllerProvider).code,
      isRemindTransactionEveryDate: true,
      createdDate: now,
      updatedDate: now,
    );

    await _ref.read(userApiProvider).add(user: newUser);
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
      _ref.invalidate(packageInfoBaseControllerProvider);
      FacebookAuth.instance.logOut();
      GoogleSignIn().signOut();
      await _ref.read(sqlHelperProvider.notifier).clearDb();
      await _auth.signOut();
      return right(null);
    } catch (e) {
      logError('Error signing out: $e');
      return Left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEither<User> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return left(Failure(error: e.message, message: e.message));
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
        return left(Failure(error: e.message, message: e.message));
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

  @override
  FutureEitherVoid resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(
            Failure(error: _ref.read(appLocalizationsProvider).emailNotFound));
      }
      return left(Failure(error: e.toString()));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
