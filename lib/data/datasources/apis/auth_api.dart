import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:budget_app/constants/string_constants.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:crypto/crypto.dart';
import 'package:budget_app/common/exception/network_exception.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Enum for tracking authentication operation status
enum AuthStatus {
  signIn,
  signUp,
  success,
  failed,
  cancelled,
}

/// Enum for social authentication providers
enum SocialAuthProvider {
  google('google.com'),
  facebook('facebook.com');

  const SocialAuthProvider(this.providerId);
  final String providerId;
}

/// Enum for Google authentication result status
enum GoogleAuthResult {
  success,
  cancelled,
  failed,
  credentialAlreadyInUse,
}

/// Helper class to hold Facebook login result data
class _FacebookLoginResult {
  final LoginStatus status;
  final AccessToken? accessToken;
  final String? rawNonce;
  final String? errorMessage;
  final UserAuthInfo? userAuthInfo;

  const _FacebookLoginResult({
    required this.status,
    this.accessToken,
    this.rawNonce,
    this.errorMessage,
    this.userAuthInfo,
  });
}

/// Helper class to hold Google login result data
class _GoogleLoginResult {
  final GoogleAuthResult status;
  final GoogleSignInAccount? account;
  final String? errorMessage;

  const _GoogleLoginResult({
    required this.status,
    this.account,
    this.errorMessage,
  });
}

class UserAuthInfo {
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;

  UserAuthInfo(
      {required this.email, this.displayName, this.photoURL, this.phoneNumber});
}

class CredentialInfo {
  final AuthCredential credential;
  final UserAuthInfo userAuthInfo;

  CredentialInfo({required this.credential, required this.userAuthInfo});
}

final authApiProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final db = ref.watch(dbProvider);
  final sharedPref = ref.watch(sharedUtilityProvider);
  return AuthAPI(auth: auth, db: db, ref: ref, sharedPref: sharedPref);
});

abstract class IAuthApi {
  FutureEither<CredentialInfo> signUp({
    required String email,
    required String password,
  });
  FutureEither<CredentialInfo> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  FutureEither<CredentialInfo> loginWithFacebook();
  FutureEither<CredentialInfo> loginWithGoogle();
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

  User get _currentUserAccount {
    return _auth.currentUser!;
  }

  /// Check if an account already exists in Firestore
  Future<bool> checkAccountExists(String email) async {
    try {
      final querySnapshot = await _db
          .collection(FirestorePath.users())
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      logError('Error checking account existence: $e');
      return false;
    }
  }

  /// Perform actual login after validation
  FutureEitherVoid signInWithCredential(
      {required CredentialInfo credentialInfo,
      required AccountType accountType}) async {
    try {
      bool isAccountExistsInDb =
          await checkAccountExists(credentialInfo.userAuthInfo.email);
      if (isAccountExistsInDb) {
        await _auth.signInWithCredential(credentialInfo.credential);
      } else {
        await _currentUserAccount.linkWithCredential(credentialInfo.credential);
        await _writeNewInfoToDB(
            uid: _currentUserAccount.uid,
            accountType: accountType,
            userAuthInfo: credentialInfo.userAuthInfo);
      }

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(
          _handleFirebaseAuthException(e, 'Error signing in with credential.'));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  /// Handle Google login errors and map them to Failure
  Failure _handleGoogleLoginError(
      _GoogleLoginResult result, String defaultError) {
    AppLocalizations loc = _ref.read(appLocalizationsProvider);
    switch (result.status) {
      case GoogleAuthResult.cancelled:
        return Failure(error: 'cancelled', message: loc.loginCancelledByUser);
      case GoogleAuthResult.failed:
      default:
        return Failure(
          error: result.errorMessage ?? 'Google login failed',
          message: defaultError,
        );
    }
  }

  Future<void> _writeNewInfoToDB(
      {required String uid,
      required AccountType accountType,
      required UserAuthInfo userAuthInfo}) async {
    String uid = _currentUserAccount.uid;
    final DateTime now = DateTime.now();
    String email = userAuthInfo.email;
    String name = userAuthInfo.displayName ?? getNameFromEmail(email);
    final newUser = UserModel(
      id: uid,
      email: email,
      balance: 0,
      profileUrl: userAuthInfo.photoURL,
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
  FutureEither<CredentialInfo> signUp({
    required String email,
    required String password,
  }) async {
    return _baseFirebaseAuthentication(
        func: () async {
          final credential = EmailAuthProvider.credential(
            email: email,
            password: password,
          );

          UserAuthInfo userAuthInfo = UserAuthInfo(
            email: email,
            displayName: getNameFromEmail(email),
          );
          return right(CredentialInfo(
              credential: credential, userAuthInfo: userAuthInfo));
        },
        defaultError: _ref.read(appLocalizationsProvider).unknownError);
  }

  @override
  FutureEitherVoid signOut(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return right(null);
      }

      await _signOutFromSocialProviders(user);

      await _auth.signOut();
      await _sharedPref.reset();

      return right(null);
    } catch (e) {
      logError('Error signing out: $e');
      return left(Failure(error: e.toString()));
    }
  }

  /// Signs out from social providers based on current user's provider
  Future<void> _signOutFromSocialProviders(User user) async {
    final providerId = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : null;

    if (providerId == null) return;

    switch (providerId) {
      case 'google.com':
        await _signOutFromGoogle();
        break;
      case 'facebook.com':
        await _signOutFromFacebook();
        break;
    }
  }

  /// Signs out from Google
  Future<void> _signOutFromGoogle() async {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
  }

  /// Signs out from Facebook
  Future<void> _signOutFromFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  @override
  FutureEither<CredentialInfo> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String defaultError =
        _ref.read(appLocalizationsProvider).invalidEmailOrPassword;
    return _baseFirebaseAuthentication(
        defaultError: defaultError,
        func: () async {
          final credential = EmailAuthProvider.credential(
            email: email,
            password: password,
          );

          final UserAuthInfo userAuthInfo = UserAuthInfo(
            email: email,
            displayName: getNameFromEmail(email),
          );
          return right(CredentialInfo(
              credential: credential, userAuthInfo: userAuthInfo));
        });
  }

  @override
  FutureEither<CredentialInfo> loginWithFacebook() async {
    final defaultError =
        _ref.read(appLocalizationsProvider).errorSignInFacebook;

    return _baseFirebaseAuthentication(
        func: () async {
          final facebookResult = await _performFacebookLogin();

          if (facebookResult.status != LoginStatus.success) {
            return left(Failure(
              error: facebookResult.status.toString(),
              message: facebookResult.errorMessage,
            ));
          }
          final credential = _createFacebookCredential(
            facebookResult.accessToken!,
            facebookResult.rawNonce,
          );
          return right(CredentialInfo(
            credential: credential,
            userAuthInfo: facebookResult.userAuthInfo!,
          ));
        },
        defaultError: defaultError);
  }

  /// Performs Facebook login and returns the result status
  Future<_FacebookLoginResult> _performFacebookLogin() async {
    try {
      await FacebookAuth.instance.logOut();

      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginTracking:
            Platform.isIOS ? LoginTracking.limited : LoginTracking.enabled,
        nonce: Platform.isIOS ? nonce : null,
        loginBehavior: LoginBehavior.webOnly,
      );

      logInfo(
          'Facebook login result: ${result.status}, message: ${result.message}');

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        logInfo('Facebook user data: $userData');
        return _FacebookLoginResult(
          status: result.status,
          accessToken: result.accessToken!,
          rawNonce: rawNonce,
          userAuthInfo: UserAuthInfo(
            email: userData['email'] as String,
            displayName: userData['name'] as String?,
            photoURL: userData['picture']['data']['url'] as String?,
          ),
        );
      } else {
        return _FacebookLoginResult(
          status: result.status,
          errorMessage: result.message,
        );
      }
    } catch (e) {
      logError('Error in Facebook login process: $e');
      return _FacebookLoginResult(
        status: LoginStatus.failed,
      );
    }
  }

  /// Creates Facebook authentication credential based on platform and token type
  AuthCredential _createFacebookCredential(
      AccessToken accessToken, String? rawNonce) {
    if (Platform.isIOS) {
      switch (accessToken.type) {
        case AccessTokenType.classic:
          final token = accessToken as ClassicToken;
          return FacebookAuthProvider.credential(token.authenticationToken!);

        case AccessTokenType.limited:
          final token = accessToken as LimitedToken;
          return OAuthCredential(
            providerId: SocialAuthProvider.facebook.providerId,
            signInMethod: 'oauth',
            idToken: token.tokenString,
            rawNonce: rawNonce,
          );
      }
    } else {
      // Android - use standard credential
      return FacebookAuthProvider.credential(accessToken.tokenString);
    }
  }

  @override
  FutureEither<CredentialInfo> loginWithGoogle() async {
    final defaultError = _ref.read(appLocalizationsProvider).errorSignInGoogle;

    return _baseFirebaseAuthentication(
        func: () async {
          final googleResult = await _performGoogleLogin();

          if (googleResult.status != GoogleAuthResult.success) {
            return left(_handleGoogleLoginError(googleResult, defaultError));
          }

          final GoogleSignInAuthentication googleAuth =
              await googleResult.account!.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          UserAuthInfo userAuthInfo = UserAuthInfo(
            email: googleResult.account!.email,
            displayName: googleResult.account!.displayName,
            photoURL: googleResult.account!.photoUrl,
          );
          return right(CredentialInfo(
              credential: credential, userAuthInfo: userAuthInfo));
        },
        defaultError: defaultError);
  }

  /// Performs Google login and returns the result status
  Future<_GoogleLoginResult> _performGoogleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return _GoogleLoginResult(status: GoogleAuthResult.cancelled);
      }

      return _GoogleLoginResult(
        status: GoogleAuthResult.success,
        account: googleUser,
      );
    } catch (e) {
      logError('Error in Google login process: $e');
      return _GoogleLoginResult(
        status: GoogleAuthResult.failed,
        errorMessage: e.toString(),
      );
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
      logError('Password reset error: ${e.code} - ${e.message}');
      return left(_handleResetPasswordException(e));
    } catch (e) {
      logError('General error in password reset: $e');
      return left(Failure(error: e.toString()));
    }
  }

  /// Handles Firebase exceptions for password reset
  Failure _handleResetPasswordException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Failure(
            error: _ref.read(appLocalizationsProvider).emailNotFound);
      case 'invalid-email':
        return Failure(error: 'Invalid email address');
      case 'too-many-requests':
        return Failure(
            error: 'Too many reset requests. Please try again later.');
      default:
        return Failure(error: e.message ?? 'Password reset failed');
    }
  }

  @override
  Future<User> signInAnonymously() {
    return _auth.signInAnonymously().then((userCredential) {
      final user = userCredential.user!;
      _writeNewInfoToDB(
          accountType: AccountType.anonymous,
          uid: user.uid,
          userAuthInfo: UserAuthInfo(email: StringConstants.emailDefault));
      return user;
    }).catchError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        if (error.code == 'network-request-failed') {
          throw NetworkException(
              message:
                  _ref.read(appLocalizationsProvider).noInternetConnection);
        }
      }
      logError('Error signing in anonymously: $error', stackTrace: stackTrace);
      throw Exception('Error signing in anonymously: $error');
    });
  }

  /// Handles Firebase authentication exceptions specific to sign up
  FutureEither<CredentialInfo> _baseFirebaseAuthentication(
      {required FutureEither<CredentialInfo> Function() func,
      required String defaultError}) async {
    try {
      return await func();
    } on FirebaseAuthException catch (e) {
      return left(_handleFirebaseAuthException(e, defaultError));
    } catch (e) {
      logError('General error in authentication: $e');
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }

  Failure _handleFirebaseAuthException(
      FirebaseAuthException e, String defaultError) {
    switch (e.code) {
      case 'weak-password':
        return Failure(
            error: e.code,
            message: _ref.read(appLocalizationsProvider).passwordTooWeak);
      case 'email-already-in-use':
        return Failure(
            error: e.code,
            message: _ref.read(appLocalizationsProvider).emailAlreadyExits);
      case 'invalid-credential':
        final errorMessage =
            _ref.read(appLocalizationsProvider).errorCredentials;
        return Failure(error: e.code, message: errorMessage);
      default:
        return Failure(error: e.code, message: e.message ?? defaultError);
    }
  }

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
