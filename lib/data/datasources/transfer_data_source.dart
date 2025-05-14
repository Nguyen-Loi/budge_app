import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class TransferData {
  FutureEitherVoid sqliteToFirebase(Ref ref,
      {required UserModel accountUserModel}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    
    // Transfer for user
    UserModel userLocalModel =
        await ref.read(userLocalProvider).getUserById('');

    UserModel newUserModel = accountUserModel.copyWith(
        balance: userLocalModel.balance,
        currencyTypeValue: userLocalModel.currencyTypeValue,
        languageCode: userLocalModel.languageCode,
        isRemindTransactionEveryDate:
            userLocalModel.isRemindTransactionEveryDate,
        createdDate: userLocalModel.createdDate);

    // Transfer for budget
    List<BudgetModel> budgetsModelLocal =
        await ref.read(budgetLocalProvider).fetch('');

    // Transfer format bugdet
    List<BudgetModel> newBudgetsModel = budgetsModelLocal
        .map((e) => e.copyWith(
              userId: newUserModel.id,
            ))
        .toList();

    // Transfer for transaction
    List<TransactionModel> transactionsModelLocal = 
        await ref.read(transactionLocalProvider).fetchTransaction(''); 

    // Transfer format transaction
    List<TransactionModel> newTransactionsModel = transactionsModelLocal
        .map((e) => e.copyWith(
              userId: newUserModel.id,
            ))
        .toList();
    
    try{
      FirebaseFirestore db = ref.read(dbProvider);
      await db.doc(FirestorePath.user(accountUserModel.id)).set(newUserModel.toMap());
      await db.collection(FirestorePath.budgets(accountUserModel.id)).add(newBudgetsModel.map((e) => e.toMap()).toList());
    }
  }
}
