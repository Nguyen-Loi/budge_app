// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';

class TransactionModel {
  final String id;
  final String budgetId;
  final int amount;
  final String note;
  final String budgetTypeValue;
  final DateTime createdDate;
  final DateTime transactionDate;
  final DateTime updatedDate;
  TransactionModel({
    required this.id,
    required this.budgetId,
    required this.amount,
    required this.note,
    required this.budgetTypeValue,
    required this.createdDate,
    required this.transactionDate,
    required this.updatedDate,
  });

  BudgetTypeEnum get budgetType => BudgetTypeEnum.fromValue(budgetTypeValue);

  TransactionCardModel toTransactionCard(Ref ref,
      {required List<BudgetModel> budgets}) {
    if (budgetId == GenId.budgetWallet()) {
      String transactionName;
      int iconId;
      switch (budgetType) {
        case BudgetTypeEnum.income:
        case BudgetTypeEnum.incomeWallet:
          transactionName = ref.read(appLocalizationsProvider).deposit;
          iconId = IconManagerData.idMoneyIn;
          break;
        case BudgetTypeEnum.expense:
        case BudgetTypeEnum.expenseWallet:
          transactionName = ref.read(appLocalizationsProvider).withdrawal;
          iconId = IconManagerData.idMoneyOut;
          break;
      }
      return TransactionCardModel(
          transaction: this,
          transactionName: transactionName,
          iconId: iconId,
          budgetType: budgetType);
    }
    final e = budgets.firstWhere((e) => e.id == budgetId);

    return TransactionCardModel(
        transaction: this,
        transactionName: e.name,
        iconId: e.iconId,
        budgetType: e.budgetType);
  }

  TransactionModel copyWith({
    String? id,
    String? budgetId,
    int? amount,
    String? note,
    String? budgetTypeValue,
    DateTime? createdDate,
    DateTime? transactionDate,
    DateTime? updatedDate,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      budgetTypeValue: budgetTypeValue ?? this.budgetTypeValue,
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
      'budgetTypeValue': budgetTypeValue,
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
      budgetTypeValue: map['budgetTypeValue'] as String,
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
    return 'TransactionModel(id: $id, budgetId: $budgetId, amount: $amount, note: $note, budgetTypeValue: $budgetTypeValue, createdDate: $createdDate, transactionDate: $transactionDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.budgetId == budgetId &&
        other.amount == amount &&
        other.note == note &&
        other.budgetTypeValue == budgetTypeValue &&
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
        budgetTypeValue.hashCode ^
        createdDate.hashCode ^
        transactionDate.hashCode ^
        updatedDate.hashCode;
  }
}
