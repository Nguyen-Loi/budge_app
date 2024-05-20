// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionModel {
  final String id;
  //Empty is wallet
  final String? budgetId;
  final int amount;
  final String note;
  final int transactionTypeValue;
  final DateTime createdDate;
  final DateTime transactionDate;
  final DateTime updatedDate;
  TransactionModel({
    required this.id,
    this.budgetId,
    required this.amount,
    required this.note,
    required this.transactionTypeValue,
    required this.createdDate,
    required this.transactionDate,
    required this.updatedDate,
  });

  TransactionTypeEnum get transactionType =>
      TransactionTypeEnum.fromValue(transactionTypeValue);

  TransactionModel copyWith({
    String? id,
    String? budgetId,
    int? amount,
    String? note,
    int? transactionTypeValue,
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


  TransactionCardModel toTransactionCard(Ref ref,
      {required List<BudgetModel> budgets}) {
    if (budgetId == null) {
      int iconId;
      String transactionName;
      switch (transactionType) {
        case TransactionTypeEnum.increase:
          iconId = 100;
          transactionName = ref.read(appLocalizationsProvider).deposit;
          break;
        case TransactionTypeEnum.decrease:
          iconId = 101;
          transactionName = ref.read(appLocalizationsProvider).withdrawal;
          break;
      }
      return TransactionCardModel(
          transaction: this, transactionName: transactionName, iconId: iconId);
    } else {
      final budget = budgets.firstWhere((e) => e.id == budgetId);
      return TransactionCardModel(
          transaction: this,
          transactionName: budget.name,
          iconId: budget.iconId);
    }
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      budgetId: map['budgetId'] != null ? map['budgetId'] as String : null,
      amount: map['amount'] as int,
      note: map['note'] as String,
      transactionTypeValue: map['transactionTypeValue'] as int,
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
