import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/constants/string_constants.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/transfer_data_source.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authApiProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final db = ref.watch(dbProvider);
  final sharedPref = ref.watch(sharedUtilityProvider);
  return AuthAPI(auth: auth, db: db, ref: ref, sharedPref: sharedPref);
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
  FutureEitherVoid signOut(BuildContext context);
  FutureEitherVoid resetPassword({
    required String email,
  });
  bool get isLogin;
  bool get isAuthenticated;
  Future<User> signInAnonymously();
}

class AuthAPI implements IAuthApi {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final Ref<Object?> _ref;
  final SharedUtility _sharedPref;
  AuthAPI({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
    required Ref<Object?> ref,
    required SharedUtility sharedPref,
  })  : _auth = auth,
        _ref = ref,
        _db = db,
        _sharedPref = sharedPref;

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
    String email = user.email ?? StringConstants.emailDefault;
    String name = user.displayName ?? getNameFromEmail(email);
    final newUser = UserModel(
      id: user.uid,
      email: email,
      balance: 0,
      profileUrl: user.photoURL,
      name: name,
      accountTypeValue: accountType.value,
      currencyTypeValue: CurrencyType.vnd.code,
      role: UserRoleEnum.normal,
      languageCode: _ref.read(languageControllerProvider).code,
      isRemindTransactionEveryDate: true,
      isActive: true,
      createdDate: now,
      updatedDate: now,
    );

    await _ref.read(userApiProvider).add(user: newUser);
  }

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential account;
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      account = await _auth.currentUser!.linkWithCredential(credential);

      await _writeNewInfoToDB(accountType: AccountType.emailAndPassword);
      return right(account.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure(
            error: _ref.read(appLocalizationsProvider).passwordTooWeak));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure(
            error: _ref.read(appLocalizationsProvider).emailAlreadyExits));
      } else if (e.code == 'credential-already-in-use') {
        return left(Failure(
            error: _ref.read(appLocalizationsProvider).emailAlreadyExits));
      }
      return left(Failure(error: e.code));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEitherVoid signOut(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return right(null);
      }
      if (!kIsWeb) {
        await TransferData.asyncData(_ref, context);
        await _ref.read(sqlHelperProvider.notifier).clearAndResetDb();
      }

      final providerId = user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : null;

      if (providerId == 'google.com') {
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
      } else if (providerId == 'facebook.com') {
        await FacebookAuth.instance.logOut();
      }

      await _auth.signOut();
      await _sharedPref.reset();

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

      await _auth.currentUser!.linkWithCredential(facebookCredential);

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
      } else if (e.code == 'credential-already-in-use') {
        // If credential is already in use, sign out anonymous and sign in normally
        await _auth.signOut();
        try {
          final LoginResult retryResult = await FacebookAuth.instance.login();
          final AuthCredential retryCredential =
              FacebookAuthProvider.credential(
                  retryResult.accessToken!.tokenString);
          await _auth.signInWithCredential(retryCredential);
          return right(null);
        } catch (retryError) {
          return left(
              Failure(error: retryError.toString(), message: defaultError));
        }
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

        await _auth.currentUser!.linkWithCredential(credential);

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
      } else if (e.code == 'credential-already-in-use') {
        // If credential is already in use, sign out anonymous and sign in normally
        await _auth.signOut();
        try {
          final GoogleSignIn retryGoogleSignIn = GoogleSignIn();
          final GoogleSignInAccount? retryGoogleUser =
              await retryGoogleSignIn.signIn();
          if (retryGoogleUser != null) {
            final GoogleSignInAuthentication retryGoogleAuth =
                await retryGoogleUser.authentication;
            final retryCredential = GoogleAuthProvider.credential(
              accessToken: retryGoogleAuth.accessToken,
              idToken: retryGoogleAuth.idToken,
            );
            await _auth.signInWithCredential(retryCredential);
            return right(null);
          }
          return left(Failure(message: defaultError));
        } catch (retryError) {
          return left(
              Failure(error: retryError.toString(), message: defaultError));
        }
      }
      return left(Failure(message: defaultError, error: e.toString()));
    } catch (e) {
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }

  @override
  bool get isLogin {
    return _auth.currentUser != null && !_auth.currentUser!.isAnonymous;
  }

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

  @override
  Future<User> signInAnonymously() {
    return _auth.signInAnonymously().then((userCredential) {
      final user = userCredential.user!;
      _writeNewInfoToDB(accountType: AccountType.anonymous);
      return user;
    }).catchError((error, stackTrace) {
      logError('Error signing in anonymously: $error', stackTrace: stackTrace);
      throw Exception('Error signing in anonymously: $error');
    });
  }

  @override
  bool get isAuthenticated => _auth.currentUser != null;
}
