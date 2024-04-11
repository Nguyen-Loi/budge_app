import 'dart:convert';

import 'package:budget_app/core/enums/transaction_type_enum.dart';

class GoalTransactionModel {
  final String id;
  final String goalId;
  final int amount;
  final String note;
  final int transactionValue;
  final DateTime createdDate;
  final DateTime updatedDate;
  GoalTransactionModel({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.note,
    required this.transactionValue,
    required this.createdDate,
    required this.updatedDate,
  });

  TransactionType get transactionType =>
      TransactionType.fromValue(transactionValue);

  GoalTransactionModel copyWith({
    String? id,
    String? goalId,
    int? amount,
    String? note,
    int? transactionValue,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return GoalTransactionModel(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      transactionValue: transactionValue ?? this.transactionValue,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'goalId': goalId,
      'amount': amount,
      'note': note,
      'transactionValue': transactionValue,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory GoalTransactionModel.fromMap(Map<String, dynamic> map) {
    return GoalTransactionModel(
      id: map['id'] as String,
      goalId: map['goalId'] as String,
      amount: map['amount'] as int,
      note: map['note'] as String,
      transactionValue: map['transactionValue'] as int,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalTransactionModel.fromJson(String source) =>
      GoalTransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GoalTransactionModel(id: $id, goalId: $goalId, amount: $amount, note: $note, transactionValue: $transactionValue, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant GoalTransactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.goalId == goalId &&
        other.amount == amount &&
        other.note == note &&
        other.transactionValue == transactionValue &&
        other.createdDate == createdDate &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        goalId.hashCode ^
        amount.hashCode ^
        note.hashCode ^
        transactionValue.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode;
  }
}
