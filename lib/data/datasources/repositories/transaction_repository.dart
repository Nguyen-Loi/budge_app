import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/transaction_api.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  if (kIsWeb) {
    return ref.watch(transactionApiProvider);
  } else {
    return ref.watch(transactionLocalProvider);
  }
});
abstract class TransactionRepository {
  Future<List<TransactionModel>> fetchTransaction(String uid);
  Future<List<TransactionModel>> getTransactionsByBudgetId(
      {required String uid, required String budgetId});
  Future<List<TransactionModel>> fetchTransactionOfMonth(
      {required String uid, required DateTime dateTime});
  FutureEither<(UserModel, TransactionModel)> updateWallet(
      {required UserModel user, required int newValue, required String note});
  FutureEither<(TransactionModel, BudgetModel, UserModel)> addBudgetTransaction(
      {required UserModel user,
      required BudgetModel budgetModel,
      required int amount,
      required String? note,
      required DateTime transactionDate});
}