import 'package:budget_app/common/exception/network_exception.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/constants/string_constants.dart';
import 'package:budget_app/core/enums/inactive_account_reason_enum.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/data/datasources/apis/chat_api.dart';
import 'package:budget_app/data/datasources/apis/device_api.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/subscription_api.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/data/models/device_model/device_model.dart';
import 'package:budget_app/data/models/subscription_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _migrateData(
      {required String fromUserId, required String toUserId}) async {
    final batch = _db.batch();
    final now = DateTime.now();

    // Get data from both users
    UserModel fromUser =
        await _ref.read(userRepositoryProvider).getUserById(fromUserId);
    UserModel toUser =
        await _ref.read(userRepositoryProvider).getUserById(toUserId);

    List<ChatModel> fromChats =
        await _ref.read(chatAPIProvider).getAllByUserId(fromUserId);
    List<ChatModel> toChats =
        await _ref.read(chatAPIProvider).getAllByUserId(toUserId);

    List<BudgetModel> fromBudgets =
        await _ref.read(budgetRepositoryProvider).getAllByUserId(fromUserId);
    List<BudgetModel> toBudgets =
        await _ref.read(budgetRepositoryProvider).getAllByUserId(toUserId);

    List<TransactionModel> fromTransactions = await _ref
        .read(transactionRepositoryProvider)
        .getAllByUserId(fromUserId);
    List<TransactionModel> toTransactions =
        await _ref.read(transactionRepositoryProvider).getAllByUserId(toUserId);

    List<DeviceModel> fromDevices =
        await _ref.read(deviceAPIProvider).getAllByUserId(fromUserId);
    List<DeviceModel> toDevices =
        await _ref.read(deviceAPIProvider).getAllByUserId(toUserId);

    List<SubscriptionModel> fromSubscriptions =
        await _ref.read(subscriptionApiProvider).getAllByUserId(fromUserId);
    List<SubscriptionModel> toSubscriptions =
        await _ref.read(subscriptionApiProvider).getAllByUserId(toUserId);

    // Merge user information - prioritize toUser data but update with fromUser's essential info
    final mergedUser = toUser.copyWith(
      profileUrl: fromUser.profileUrl ?? toUser.profileUrl,
      name: fromUser.name == StringConstants.nameDefault
          ? toUser.name
          : fromUser.name,
      accountTypeValue: fromUser.accountTypeValue,
      currencyTypeValue: fromUser.currencyTypeValue,
      phoneNumber: fromUser.phoneNumber ?? toUser.phoneNumber,
      languageCode: fromUser.languageCode,
      isRemindTransactionEveryDate: fromUser.isRemindTransactionEveryDate,
      subscriptionPlan: fromUser.subscriptionPlan ?? toUser.subscriptionPlan,
      subscriptionExpiryDate:
          fromUser.subscriptionExpiryDate ?? toUser.subscriptionExpiryDate,
      updatedDate: now,
    );

    // Combine all transactions
    final allTransactions = [...fromTransactions, ...toTransactions]
        .map((t) => t.copyWith(userId: toUserId, ))
        .toList();

    // Calculate total balance from all transactions
    int totalBalance = 0;
    for (var transaction in allTransactions) {
      totalBalance += transaction.amount;
    }

    // Update user with new balance
    final finalUser = mergedUser.copyWith(balance: totalBalance);

    // Combine budgets with priority handling
    final Map<String, BudgetModel> budgetMap = {};

    // First add toUser budgets
    for (var budget in toBudgets) {
      budgetMap[budget.name] = budget.copyWith(userId: toUserId);
    }

    // Then add fromUser budgets, updating existing ones with priority
    for (var budget in fromBudgets) {
      final existingBudget = budgetMap[budget.name];
      if (existingBudget != null) {
        // Recalculate current amount based on transactions for this budget
        int budgetCurrentAmount = 0;
        for (var transaction in allTransactions) {
          if (transaction.budgetId == budget.id ||
              transaction.budgetId == existingBudget.id) {
            budgetCurrentAmount += transaction.amount;
          }
        }
        // Prioritize fromUser's limit
        budgetMap[budget.name] = existingBudget.copyWith(
          currentAmount: budgetCurrentAmount,
          budgetLimit: budget.budgetLimit,
          iconName: budget.iconName,
          updatedDate: now,
        );
      } else {
        // Calculate current amount for new budget
        int budgetCurrentAmount = 0;
        for (var transaction in allTransactions) {
          if (transaction.budgetId == budget.id) {
             budgetCurrentAmount += transaction.amount;
          }
        }
        budgetMap[budget.name] = budget.copyWith(
          userId: toUserId,
          currentAmount: budgetCurrentAmount,
          updatedDate: now,
        );
      }
    }

    // Combine devices (only add unique devices)
    final List<DeviceModel> combinedDevices = [...toDevices];
    for (var fromDevice in fromDevices) {
      if (!fromDevice.infoDeviceIsExist(combinedDevices)) {
        combinedDevices.add(fromDevice.copyWith(userId: toUserId, updatedDate: now));
      }
    }

    // Combine chats
    List<ChatModel> combinedChats = [...fromChats, ...toChats]
        .map((chat) => chat.copyWith(userId: toUserId))
        .toList();

    // Combine subscriptions
    final combinedSubscriptions = [...fromSubscriptions, ...toSubscriptions]
        .map((sub) => sub.copyWith(userId: toUserId))
        .toList();

    // Update user document
    batch.set(
      _db.doc(FirestorePath.user(toUserId)),
      finalUser.toMap(),
    );

    // Delete old user and its data
    batch.delete(_db.doc(FirestorePath.user(fromUserId)));

    // Add combined budgets
    for (var budget in budgetMap.values) {
      batch.set(
        _db.doc(FirestorePath.budget(uid: toUserId, budgetId: budget.id)),
        budget.toMap(),
      );
    }

    // Add combined transactions
    for (var transaction in allTransactions) {
      batch.set(
        _db
            .collection(FirestorePath.transactions(uid: toUserId))
            .doc(transaction.id),
        transaction.toMap(),
      );
    }

    // Add combined devices
    for (var device in combinedDevices) {
      batch.set(
        _db.collection(FirestorePath.devices(uid: toUserId)).doc(device.id),
        device.toMap(),
      );
    }

    // Add combined chats
    if (fromChats.isNotEmpty && toChats.isNotEmpty) {
      combinedChats = combinedChats.map((chat) {
        return chat.copyWith(deletedDate: now, updatedDate: now);
      }).toList();
    }
     for (var chat in combinedChats) {
        batch.set(
          _db.collection(FirestorePath.chats(uid: toUserId)).doc(chat.id),
          chat.toMap(),
        );
      }

    // Add combined subscriptions
    for (var subscription in combinedSubscriptions) {
      batch.set(
        _db
            .collection(FirestorePath.subscriptions(uid: toUserId))
            .doc(subscription.id),
        subscription.toMap(),
      );
    }

    // Clean up old user's collections
    // Delete old from user
    UserModel deletedUser = fromUser.copyWith(
      isActive: false,
      inactiveReason: InactiveAccountReasonEnum.transferNewAccount.code,
      updatedDate: now
    );

    batch.set(
      _db.doc(FirestorePath.user(fromUserId)),
      deletedUser.toMap(),
    );

    await batch.commit();
  }
}
