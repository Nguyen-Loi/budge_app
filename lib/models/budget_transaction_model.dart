// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_app/core/enums/transaction_type_enum.dart';

class BudgetTransactionModel {
  final String id;
  final String budgetId;
  final int amount;
  final String note;
  final int transactionTypeValue;
  final DateTime createdDate;
  final DateTime transactionDate;
  final DateTime updatedDate;
  BudgetTransactionModel({
    required this.id,
    required this.budgetId,
    required this.amount,
    required this.note,
    required this.transactionTypeValue,
    required this.createdDate,
    required this.transactionDate,
    required this.updatedDate,
  });
 

  TransactionType get transactionType =>
      TransactionType.fromValue(transactionTypeValue);


  BudgetTransactionModel copyWith({
    String? id,
    String? budgetId,
    int? amount,
    String? note,
    int? transactionTypeValue,
    DateTime? createdDate,
    DateTime? transactionDate,
    DateTime? updatedDate,
  }) {
    return BudgetTransactionModel(
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

  factory BudgetTransactionModel.fromMap(Map<String, dynamic> map) {
    return BudgetTransactionModel(
      id: map['id'] as String,
      budgetId: map['budgetId'] as String,
      amount: map['amount'] as int,
      note: map['note'] as String,
      transactionTypeValue: map['transactionTypeValue'] as int,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      transactionDate: DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetTransactionModel.fromJson(String source) => BudgetTransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetTransactionModel(id: $id, budgetId: $budgetId, amount: $amount, note: $note, transactionTypeValue: $transactionTypeValue, createdDate: $createdDate, transactionDate: $transactionDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant BudgetTransactionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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
