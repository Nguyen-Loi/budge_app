import 'dart:convert';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';

class TransactionModel {
  final String id;
  final String budgetId;
  final int amount;
  final String note;
  final String transactionTypeValue;
  final DateTime createdDate;
  final DateTime transactionDate;
  final DateTime updatedDate;
  TransactionModel({
    required this.id,
    required this.budgetId,
    required this.amount,
    required this.note,
    required this.transactionTypeValue,
    required this.createdDate,
    required this.transactionDate,
    required this.updatedDate,
  });

  TransactionTypeEnum get transactionType =>
      TransactionTypeEnum.fromValue(transactionTypeValue);

  TransactionCardModel toTransactionCard(Ref ref,
      {required List<BudgetModel> budgets}) {
    final budgetOfTransaction =
        budgets.firstWhereOrNull((e) => e.id == budgetId);
    if (budgetOfTransaction != null) {
      return TransactionCardModel(
          transaction: this,
          transactionName: budgetOfTransaction.name,
          iconId: budgetOfTransaction.iconId,
          transactionType: transactionType);
    }
    // Handle transaction of wallet
    String transactionName = '';
    int iconId = 1;
    switch (transactionType) {
      case TransactionTypeEnum.incomeWallet:
        transactionName = ref.read(appLocalizationsProvider).deposit;
        iconId = IconManagerData.idMoneyIn;
        break;
      case TransactionTypeEnum.expenseWallet:
        transactionName = ref.read(appLocalizationsProvider).withdrawal;
        iconId = IconManagerData.idMoneyOut;
        break;
      case TransactionTypeEnum.incomeBudget:
      case TransactionTypeEnum.expenseBudget:
        break;
    }
    return TransactionCardModel(
        transaction: this,
        transactionName: transactionName,
        iconId: iconId,
        transactionType: transactionType);
  }

  TransactionModel copyWith({
    String? id,
    String? budgetId,
    int? amount,
    String? note,
    String? transactionTypeValue,
    DateTime? createdDate,
    DateTime? transactionDate,
    DateTime? updatedDate,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      transactionTypeValue: transactionTypeValue ?? this.transactionTypeValue,
      createdDate: createdDate ?? this.createdDate,
      transactionDate: transactionDate ?? this.transactionDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'budgetId': budgetId,
      'amount': amount,
      'note': note,
      'transactionTypeValue': transactionTypeValue,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      budgetId: map['budgetId'] as String,
      amount: map['amount'] as int,
      note: map['note'] as String,
      transactionTypeValue: map['transactionTypeValue'] as String,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      transactionDate:
          DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionModel(id: $id, budgetId: $budgetId, amount: $amount, note: $note, transactionTypeValue: $transactionTypeValue, createdDate: $createdDate, transactionDate: $transactionDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.budgetId == budgetId &&
        other.amount == amount &&
        other.note == note &&
        other.transactionTypeValue == transactionTypeValue &&
        other.createdDate == createdDate &&
        other.transactionDate == transactionDate &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        budgetId.hashCode ^
        amount.hashCode ^
        note.hashCode ^
        transactionTypeValue.hashCode ^
        createdDate.hashCode ^
        transactionDate.hashCode ^
        updatedDate.hashCode;
  }
}
