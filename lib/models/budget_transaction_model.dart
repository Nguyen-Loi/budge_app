import 'dart:convert';

import 'package:budget_app/core/enums/transaction_type_enum.dart';

class BudgetTransactionModel {
  final String id;
  final int amount;
  final String note;
  final TransactionType transactionType;
  final DateTime createdDate;
  final DateTime updatedDate;
  BudgetTransactionModel({
    required this.id,
    required this.amount,
    required this.note,
    required this.transactionType,
    required this.createdDate,
    required this.updatedDate,
  });

  BudgetTransactionModel copyWith({
    int? amount,
    String? note,
    TransactionType? transactionType,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return BudgetTransactionModel(
      id: id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      transactionType: transactionType ?? this.transactionType,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'note': note,
      'transactionType': transactionType.value,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory BudgetTransactionModel.fromMap(Map<String, dynamic> map) {
    return BudgetTransactionModel(
      id: map['id'] as String,
      amount: map['amount'] as int,
      note: map['note'] as String,
      transactionType: TransactionType.fromValue(map['transactionType'] as int),
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetTransactionModel.fromJson(String source) =>
      BudgetTransactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetTransactionModel(budgetId: $id, amount: $amount, note: $note, transactionType: $transactionType, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant BudgetTransactionModel other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.note == note &&
        other.transactionType == transactionType &&
        other.createdDate == createdDate &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        note.hashCode ^
        transactionType.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode;
  }
}
