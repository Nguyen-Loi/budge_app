import 'dart:async';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/enums/inactive_account_reason_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/budget_api.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/apis/transaction_api.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/data/services/default_budget_service.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

/// Enum to represent the presence of data in local SQLite and remote API
enum DataPresence {
  noData, // No data in both local SQLite and remote API
  localOnly, // Data exists only in local SQLite
  remoteOnly, // Data exists only in remote API
  conflict, // Data exists in both local SQLite and remote API
}

/// Enum to represent synchronization actions to be performed
enum SyncAction {
  noAction, // No synchronization needed
  syncLocalToRemote, // Sync local SQLite data to remote API
  syncRemoteToLocal, // Sync remote API data to local SQLite
  showConflictDialog, // Show dialog to user for conflict resolution
  mergeData, // Automatically merge data from both sources
}

final String _budgetLocalKey = 'budgetsModelLocal';
final String _budgetApiKey = 'budgetsModelApi';
final String _transactionLocalKey = 'transactionsModelLocal';
final String _transactionApiKey = 'transactionsModelApi';
final String _userApiKey = 'userModelApi';

class TransferData {
  TransferData._();

  static DataPresence _getDataPresence(bool hasLocalData, bool hasRemoteData) {
    if (!hasLocalData && !hasRemoteData) {
      return DataPresence.noData;
    } else if (hasLocalData && !hasRemoteData) {
      return DataPresence.localOnly;
    } else if (!hasLocalData && hasRemoteData) {
      return DataPresence.remoteOnly;
    } else {
      return DataPresence.conflict;
    }
  }

  static SyncAction decideSyncAction(
    DataPresence state, {
    bool showDialogConflict = false,
  }) {
    switch (state) {
      case DataPresence.noData:
        logInfo("No data found in both local and remote - no action needed");
        return SyncAction.noAction;
      case DataPresence.localOnly:
        logInfo("Data found only locally - will sync to remote");
        return SyncAction.syncLocalToRemote;
      case DataPresence.remoteOnly:
        logInfo("Data found only remotely - will sync to local");
        return SyncAction.syncRemoteToLocal;
      case DataPresence.conflict:
        if (showDialogConflict) {
          logInfo("Data conflict detected - will show dialog to user");
          return SyncAction.showConflictDialog;
        } else {
          logInfo("Data conflict detected - will auto-merge data");
          return SyncAction.mergeData;
        }
    }
  }

  /// Shows a conflict resolution dialog to the user with multiple options
  static Future<Either<Failure, void>> _showConflictDialog(
    Ref ref,
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    if (!context.mounted) {
      return left(Failure(message: 'Context is not mounted'));
    }

    var result = Either<Failure, void>.right(null);

    AppLocalizations loc = context.loc;
    UserModel userApi = data[_userApiKey];

    await BDialogInfo(
      title: loc.dataSyncConflict,
      message: loc.dataSyncConflictDesc(userApi.email),
      dialogInfoType: BDialogInfoType.warning,
    ).presentCustomAction(context, actions: [
      Row(
        children: [
          Expanded(
            child: BButton(
              title: loc.combineData,
              size: ButtonSize.small,
              onPressed: () async {
                Navigator.of(context).pop();
                result = await merge(ref, data: data);
              },
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: BButton(
              title: loc.overwriteWithNewData,
              size: ButtonSize.small,
              onPressed: () async {
                Navigator.of(context).pop();
                result = await _apiToSqlite(ref, data: data);
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: BButton(
              title: loc.useCurrentData,
              size: ButtonSize.small,
              onPressed: () async {
                Navigator.of(context).pop();
                result = await _sqliteToApi(ref, data: data);
              },
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(child: SizedBox.shrink())
        ],
      )
    ]);

    return result;
  }

  static FutureEitherVoid asyncData(Ref ref, BuildContext context,
      {bool canShowDialogConflig = false, String? preUid}) async {
    try {
      if (kIsWeb) {
        logInfo("Running on web - skipping sync");
        return right(null);
      }

      User? user = ref.read(authProvider).currentUser;
      if (user == null) {
        logError("User is null - cannot perform sync");
        return left(Failure(message: 'User is null'));
      }

      String uid = user.uid;
      logInfo("Starting data sync for user: $uid");
      UserModel userApi = await ref.read(userApiProvider).getUserById(uid);

      List<BudgetModel> budgetsLocal =
          await _safeUidLocalBudgets(ref, uid: uid, preUid: preUid);
      List<BudgetModel> budgetsApi =
          await ref.read(budgetAPIProvider).fetch(uid);

      List<TransactionModel> transactionsLocal =
          await _safeUidLocalTransactions(ref, uid: uid, preUid: preUid);
      List<TransactionModel> transactionsApi =
          await ref.read(transactionApiProvider).fetchTransaction(uid);

      final data = {
        _budgetLocalKey: budgetsLocal,
        _budgetApiKey: budgetsApi,
        _transactionLocalKey: transactionsLocal,
        _transactionApiKey: transactionsApi,
        _userApiKey: userApi,
      };

      // Determine data presence
      bool hasLocalData =
          transactionsLocal.isNotEmpty;
      bool hasRemoteData =  transactionsApi.isNotEmpty;

      logInfo(
          "Local data present: $hasLocalData, Remote data present: $hasRemoteData");

      DataPresence dataPresence = _getDataPresence(hasLocalData, hasRemoteData);
      SyncAction syncAction = decideSyncAction(dataPresence,
          showDialogConflict: canShowDialogConflig);

      logInfo("Determined sync action: $syncAction");

      unawaited(_updateStatusAccountAnonymously(ref,
          uid: uid, preUid: preUid, data: data));

      // Execute sync action based on decision
      switch (syncAction) {
        case SyncAction.noAction:
          logInfo(
              "No sync action needed - loading current data from API to ensure consistency");
          return await _apiToSqlite(ref, data: data);

        case SyncAction.syncLocalToRemote:
          logInfo("Syncing local data to remote");
          return await _sqliteToApi(ref, data: data);

        case SyncAction.syncRemoteToLocal:
          logInfo("Syncing remote data to local");
          return await _apiToSqlite(ref, data: data);

        case SyncAction.showConflictDialog:
          logInfo("Showing conflict resolution dialog to user");
          if (!context.mounted) {
            return left(Failure(message: 'Context is not mounted'));
          }
          return await _showConflictDialog(ref, context, data);

        case SyncAction.mergeData:
          logInfo("Auto-merging conflicting data");
          return await merge(ref, data: data);
      }
    } catch (e) {
      logError("Error during data sync: $e");
      return left(Failure(message: 'Error transferring data: $e'));
    }
  }

  static Future<void> _updateStatusAccountAnonymously(Ref ref,
      {required String uid,
      required String? preUid,
      required Map<String, dynamic> data}) async {
    if (uid == preUid || preUid == null) {
      return;
    }
    logInfo(
        "Updating account temp (Anonymously) status to active for UID: $preUid");
    UserModel userModel = data[_userApiKey];
    userModel = userModel.copyWith(
        isActive: false,
        id: preUid,
        inactiveReason: InactiveAccountReasonEnum.transferNewAccount.code);
    await ref.read(userApiProvider).updateUser(user: userModel);
  }

  static Future<List<BudgetModel>> _safeUidLocalBudgets(
    Ref ref, {
    required String uid,
    required String? preUid,
  }) async {
    String uidSqlite = preUid ?? uid;
    List<BudgetModel> budgetsLocal =
        await ref.read(budgetLocalProvider).fetch(uidSqlite);
    if (preUid == null) {
      return budgetsLocal;
    }
    budgetsLocal = budgetsLocal.map((b) => b.copyWith(userId: uid)).toList();
    await ref.read(budgetLocalProvider).updateAll(budgets: budgetsLocal);
    return budgetsLocal;
  }

  static Future<List<TransactionModel>> _safeUidLocalTransactions(
    Ref ref, {
    required String uid,
    required String? preUid,
  }) async {
    String uidSqlite = preUid ?? uid;
    List<TransactionModel> transactionsLocal =
        await ref.read(transactionLocalProvider).fetchTransaction(uidSqlite);
    if (preUid == null) {
      return transactionsLocal;
    }
    transactionsLocal =
        transactionsLocal.map((t) => t.copyWith(userId: uid)).toList();
    await ref
        .read(transactionLocalProvider)
        .updateAll(transactions: transactionsLocal);
    return transactionsLocal;
  }


  static FutureEitherVoid _sqliteToApi(Ref ref,
      {required Map<String, dynamic> data}) async {
    try {
      logInfo("Starting sync from SQLite to API");
      FirebaseFirestore db = ref.read(dbProvider);

      UserModel userModelApi = data[_userApiKey];
      String userId = userModelApi.id;

      List<BudgetModel> budgets = data[_budgetLocalKey];
      List<TransactionModel> transactions = data[_transactionLocalKey];

      logInfo(
          "Syncing ${budgets.length} budgets and ${transactions.length} transactions for user: $userId");

      WriteBatch batch = db.batch();

      // 1. Delete all budgets for this user
      final budgetsCollection =
          db.collection(FirestorePath.budgets(uid: userId));
      final budgetsSnapshot = await budgetsCollection.get();
      for (final doc in budgetsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 2. Delete all transactions for this user
      final transactionsCollection =
          db.collection(FirestorePath.transactions(uid: userId));
      final transactionsSnapshot = await transactionsCollection.get();
      for (final doc in transactionsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Insert new budgets
      for (var budgetModel in budgets) {
        final docRef = budgetsCollection.doc(budgetModel.id);
        batch.set(docRef, budgetModel.toMap());
      }

      // Insert new transactions
      for (var transactionModel in transactions) {
        final docRef = transactionsCollection.doc(transactionModel.id);
        batch.set(docRef, transactionModel.toMap());
      }

      await batch.commit();

      logInfo("Successfully synced data from SQLite to API");
      return right(null);
    } catch (e) {
      logError("Error transferring data to Firebase: $e");
      return left(Failure(message: 'Error transferring data to Firebase: $e'));
    }
  }

  static FutureEitherVoid _apiToSqlite(Ref ref,
      {required Map<String, dynamic> data}) async {
    try {
      logInfo("Starting sync from API to SQLite");

      UserModel userModel = data[_userApiKey];
      List<BudgetModel> budgets = data[_budgetApiKey];
      List<TransactionModel> transactions = data[_transactionApiKey];

      logInfo(
          "Syncing ${budgets.length} budgets and ${transactions.length} transactions from API");

      List<BudgetModel> budgetsLocal = data[_budgetLocalKey];
      if (budgetsLocal.isEmpty || budgets.isEmpty) {
        logInfo("Creating default budgets as no budgets found");
        List<BudgetModel> defaultBudgets =
            DefaultBudgetService.createDefaultBudgets(
          userId: userModel.id,
          localizations: ref.read(appLocalizationsProvider),
        );
        budgets.addAll(defaultBudgets);
      }

      final db = ref.read(sqlHelperProvider);
      if (db == null) {
        return left(Failure(message: 'Database is not initialized'));
      }
      // Start SQLite batch operation
      final Batch batch = db.batch();

      // Remove all data from tables
      batch.delete(TableName.budget);
      batch.delete(TableName.transaction);


      // Add budgets to SQLite
      for (final budget in budgets) {
        batch.insert(
          TableName.budget,
          budget.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Add transactions to SQLite
      for (final transaction in transactions) {
        batch.insert(
          TableName.transaction,
          transaction.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);

      logSuccess("Successfully synced data from API to SQLite");
      return right(null);
    } catch (e) {
      logError("Error transferring data to SQLite: $e");
      return left(Failure(message: 'Error transferring data to SQLite: $e'));
    }
  }

  static FutureEitherVoid merge(Ref ref, {Map<String, dynamic>? data}) async {
    try {
      logInfo("Starting data merge process");

      if (kIsWeb) {
        logInfo("Running on web - skipping merge");
        return right(null);
      }
      User? user = ref.read(authProvider).currentUser;
      if (user == null) {
        return left(Failure(message: 'User not logged in'));
      }
      String userId = user.uid;

      List<BudgetModel> budgetsLocal = data?[_budgetLocalKey] ??
          await ref.read(budgetLocalProvider).fetch(userId);
      List<BudgetModel> budgetsApi = data?[_budgetApiKey] ??
          await ref.read(budgetAPIProvider).fetch(userId);
      UserModel userApi = data?[_userApiKey] ??
          await ref.read(userApiProvider).getUserById(userId);

      List<TransactionModel> transactionsLocal = data?[_transactionLocalKey] ??
          await ref.read(transactionLocalProvider).fetchTransaction(userId);
      List<TransactionModel> transactionsApi = data?[_transactionApiKey] ??
          await ref.read(transactionApiProvider).fetchTransaction(userId);

      logInfo(
          "Merge data comparison: Local(${budgetsLocal.length} budgets, ${transactionsLocal.length} transactions) vs API(${budgetsApi.length} budgets, ${transactionsApi.length} transactions)");

      bool isSameData =
          budgetsLocal.equals(budgetsApi) &&
          transactionsLocal.equals(transactionsApi);
      if (isSameData) {
        logInfo("No data changes detected - skipping merge");
        return right(null);
      }

      logInfo("Data differences detected - proceeding with merge");

      // Merge Budgets
      logInfo("Merging budgets...");
      Map<String, BudgetModel> mergedBudgets = {};
      for (var budget in budgetsLocal) {
        mergedBudgets[budget.id] = budget;
      }
      for (var budget in budgetsApi) {
        if (mergedBudgets.containsKey(budget.id)) {
          final localBudget = mergedBudgets[budget.id]!;
          if (budget.updatedDate.isAfter(localBudget.updatedDate)) {
            logInfo(
                "Using remote budget ${budget.id} (newer: ${budget.updatedDate})");
            mergedBudgets[budget.id] = budget;
          } else {
            logInfo(
                "Keeping local budget ${budget.id} (newer: ${localBudget.updatedDate})");
          }
        } else {
          logInfo("Adding new remote budget ${budget.id}");
          mergedBudgets[budget.id] = budget;
        }
      }
      List<BudgetModel> finalBudgets = mergedBudgets.values.toList();

      // Merge Transactions
      logInfo("Merging transactions...");
      Map<String, TransactionModel> mergedTransactions = {};
      for (var tx in transactionsLocal) {
        mergedTransactions[tx.id] = tx;
      }
      for (var tx in transactionsApi) {
        if (mergedTransactions.containsKey(tx.id)) {
          final localTx = mergedTransactions[tx.id]!;
          if (tx.updatedDate.isAfter(localTx.updatedDate)) {
            logInfo(
                "Using remote transaction ${tx.id} (newer: ${tx.updatedDate})");
            mergedTransactions[tx.id] = tx;
          } else {
            logInfo(
                "Keeping local transaction ${tx.id} (newer: ${localTx.updatedDate})");
          }
        } else {
          logInfo("Adding new remote transaction ${tx.id}");
          mergedTransactions[tx.id] = tx;
        }
      }
      List<TransactionModel> finalTransactions =
          mergedTransactions.values.toList();

      // Merge budgets with transactions
      Map<String, BudgetModel> updatedBudgets = {
        for (var budget in finalBudgets)
          budget.id: budget.copyWith(currentAmount: 0)
      };
      for (var tx in finalTransactions) {
        final budgetId = tx.budgetId;
        if (updatedBudgets.containsKey(budgetId)) {
          var budget = updatedBudgets[budgetId]!;
          int txAmount = tx.amount;
          if (tx.transactionType == TransactionTypeEnum.expense) {
            txAmount = txAmount.abs() * -1;
          }
          budget = budget.copyWith(
            currentAmount: budget.currentAmount + txAmount,
          );
          updatedBudgets[budgetId] = budget;
        }
      }
      finalBudgets = updatedBudgets.values.toList();

      // Total balance
      final int totalBalance = finalBudgets.fold(
        0,
        (value, budget) => value + budget.currentAmount,
      );
      userApi = userApi.copyWith(
        balance: totalBalance,
        updatedDate: DateTime.now(),
      );

      // Write merged data to SQLite
      final db = ref.read(sqlHelperProvider);
      if (db == null) {
        return left(Failure(message: 'Database is not initialized'));
      }
      final Batch batch = db.batch();
      batch.delete(TableName.budget);
      batch.delete(TableName.transaction);
      for (final budget in finalBudgets) {
        batch.insert(
          TableName.budget,
          budget.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final tx in finalTransactions) {
        batch.insert(
          TableName.transaction,
          tx.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
      Map<String, dynamic> newData = {
        _budgetLocalKey: finalBudgets,
        _transactionLocalKey: finalTransactions,
        _userApiKey: userApi
      };
      unawaited(_sqliteToApi(ref, data: newData));

      logInfo(
          "Successfully merged data: ${finalBudgets.length} budgets, ${finalTransactions.length} transactions");
      return right(null);
    } catch (e) {
      logError("Error during data merge: $e");
      return left(Failure(message: 'Error transferring data: $e'));
    }
  }
}
