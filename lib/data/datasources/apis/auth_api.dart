import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:budget_app/common/exception/network_exception.dart';
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

/// Enum for Facebook authentication result status
enum FacebookAuthResult {
  success,
  cancelled,
  failed,
  noAccessToken,
  invalidToken,
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
  final FacebookAuthResult status;
  final AccessToken? accessToken;
  final String? rawNonce;
  final String? errorMessage;

  const _FacebookLoginResult({
    required this.status,
    this.accessToken,
    this.rawNonce,
    this.errorMessage,
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
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      final account = await _auth.currentUser!.linkWithCredential(credential);
      await _writeNewInfoToDB(accountType: AccountType.emailAndPassword);

      return right(account.user!);
    } on FirebaseAuthException catch (e) {
      return left(_handleSignUpFirebaseException(e));
    } catch (e) {
      logError('General error in sign up: $e');
      return left(Failure(error: e.toString()));
    }
  }

  /// Handles Firebase authentication exceptions specific to sign up
  Failure _handleSignUpFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Failure(
            error: _ref.read(appLocalizationsProvider).passwordTooWeak);
      case 'email-already-in-use':
      case 'credential-already-in-use':
        return Failure(
            error: _ref.read(appLocalizationsProvider).emailAlreadyExits);
      default:
        return Failure(error: e.code);
    }
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
  FutureEither<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(_currentUserAccount());
    } on FirebaseAuthException catch (e) {
      logError('Email/Password login error: ${e.code} - ${e.message}');
      return left(Failure(
        error: e.message ?? 'Login failed',
        message: _ref.read(appLocalizationsProvider).invalidEmailOrPassword,
      ));
    } catch (e) {
      logError('General error in email/password login: $e');
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEitherVoid loginWithFacebook() async {
    final defaultError =
        _ref.read(appLocalizationsProvider).errorSignInFacebook;

    try {
      final facebookResult = await _performFacebookLogin();

      switch (facebookResult.status) {
        case FacebookAuthResult.success:
          await _handleSuccessfulFacebookLogin(facebookResult);
          await _writeNewInfoToDB(accountType: AccountType.facebook);
          return right(null);

        case FacebookAuthResult.cancelled:
          return left(Failure(
            error: 'Facebook login was cancelled by user',
            message: defaultError,
          ));

        case FacebookAuthResult.noAccessToken:
          return left(Failure(
            error: 'No access token received from Facebook',
            message: defaultError,
          ));

        case FacebookAuthResult.invalidToken:
          return left(Failure(
            error: 'Invalid Facebook token received',
            message: defaultError,
          ));

        case FacebookAuthResult.failed:
          return left(Failure(
            error: facebookResult.errorMessage ?? 'Facebook login failed',
            message: defaultError,
          ));
      }
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(
          e, defaultError, SocialAuthProvider.facebook);
    } catch (e) {
      logError('General error in Facebook login: $e');
      return left(Failure(error: e.toString(), message: defaultError));
    }
  }

  /// Performs Facebook login and returns the result status
  Future<_FacebookLoginResult> _performFacebookLogin() async {
    try {
      // Always clear Facebook login data to force fresh login
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

      logError(
          'Facebook login result: ${result.status}, message: ${result.message}');

      if (result.status != LoginStatus.success) {
        final errorMsg = 'Facebook login failed: ${result.status}';
        logError(errorMsg);
        return _FacebookLoginResult(
          status: FacebookAuthResult.failed,
          errorMessage: result.message,
        );
      }

      if (result.accessToken == null) {
        logError('No access token received from Facebook');
        return _FacebookLoginResult(status: FacebookAuthResult.noAccessToken);
      }

      // Validate the access token
      try {
        final userData = await FacebookAuth.instance.getUserData();
        logError('Facebook user data: $userData');
      } catch (userDataError) {
        logError('Error getting Facebook user data: $userDataError');
        return _FacebookLoginResult(status: FacebookAuthResult.invalidToken);
      }

      return _FacebookLoginResult(
        status: FacebookAuthResult.success,
        accessToken: result.accessToken!,
        rawNonce: rawNonce,
      );
    } catch (e) {
      logError('Error in Facebook login process: $e');
      return _FacebookLoginResult(
        status: FacebookAuthResult.failed,
        errorMessage: e.toString(),
      );
    }
  }

  /// Handles successful Facebook login by creating Firebase credential and signing in
  Future<void> _handleSuccessfulFacebookLogin(
      _FacebookLoginResult result) async {
    final AuthCredential facebookCredential = _createFacebookCredential(
      result.accessToken!,
      result.rawNonce,
    );

    // Always sign out Firebase user first to ensure fresh authentication
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }

    await _auth.signInWithCredential(facebookCredential);
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

  /// Handles Firebase authentication exceptions for social login
  Either<Failure, void> _handleFirebaseAuthException(
    FirebaseAuthException e,
    String defaultError,
    SocialAuthProvider provider,
  ) {
    logError(
        'Firebase Auth Error in ${provider.name} login: ${e.code} - ${e.message}');

    switch (e.code) {
      case 'account-exists-with-different-credential':
        return left(Failure(error: e.message, message: e.message));

      case 'invalid-credential':
        final errorMessage = provider == SocialAuthProvider.facebook
            ? 'Facebook login configuration error. Please try again or contact support.'
            : _ref.read(appLocalizationsProvider).errorCredentials;
        return left(Failure(error: errorMessage, message: errorMessage));

      default:
        return left(Failure(message: defaultError, error: e.toString()));
    }
  }

  @override
  FutureEitherVoid loginWithGoogle() async {
    final defaultError = _ref.read(appLocalizationsProvider).errorSignInGoogle;

    try {
      final googleResult = await _performGoogleLogin();

      switch (googleResult.status) {
        case GoogleAuthResult.success:
          await _handleSuccessfulGoogleLogin(googleResult.account!);
          await _writeNewInfoToDB(accountType: AccountType.google);
          return right(null);

        case GoogleAuthResult.cancelled:
          return left(Failure(
            error: 'Google login was cancelled by user',
            message: defaultError,
          ));

        case GoogleAuthResult.credentialAlreadyInUse:
          return await _handleGoogleCredentialAlreadyInUse(defaultError);

        case GoogleAuthResult.failed:
          return left(Failure(
            error: googleResult.errorMessage ?? 'Google login failed',
            message: defaultError,
          ));
      }
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(
          e, defaultError, SocialAuthProvider.google);
    } catch (e) {
      logError('General error in Google login: $e');
      return left(Failure(error: e.toString(), message: defaultError));
    }
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

  /// Handles successful Google login by creating Firebase credential and signing in
  Future<void> _handleSuccessfulGoogleLogin(
      GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.currentUser!.linkWithCredential(credential);
  }

  /// Handles the case where Google credential is already in use
  Future<Either<Failure, void>> _handleGoogleCredentialAlreadyInUse(
      String defaultError) async {
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
      return left(Failure(error: retryError.toString(), message: defaultError));
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
      _writeNewInfoToDB(accountType: AccountType.anonymous);
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
