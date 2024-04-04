import 'dart:convert';
import 'package:budget_app/core/enums/transaction_type_enum.dart';

class GoalTransactionModel {
  final String goalId;
  final int amount;
  final String note;
  final TransactionType transactionType;
  final DateTime createdDate;
  final DateTime updatedDate;
  GoalTransactionModel({
    required this.goalId,
    required this.amount,
    required this.note,
    required this.transactionType,
    required this.createdDate,
    required this.updatedDate,
  });

  GoalTransactionModel copyWith({
    String? goalId,
    int? amount,
    String? note,
    TransactionType? transactionType,
  }) {
    return GoalTransactionModel(
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      transactionType: transactionType ?? this.transactionType,
      createdDate: createdDate,
      updatedDate: updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'goalId': goalId,
      'amount': amount,
      'note': note,
      'transactionType': TransactionType.fromValue(transactionType.value),
      'createdDate': createdDate,
      'updatedDate': updatedDate
    };
  }

  factory GoalTransactionModel.fromMap(Map<String, dynamic> map) {
    return GoalTransactionModel(
      goalId: map['goalId'] as String,
      amount: map['amount'] as int,
      note: map['note'] as String,
      transactionType: TransactionType.fromValue(map['transactionType'] as int),
      createdDate: map['createdDate'] as DateTime,
      updatedDate: map['updatedDate'] as DateTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalTransactionModel.fromJson(String source) =>
      GoalTransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GoalTransactionModel(goalId: $goalId, amount: $amount, note: $note, transactionType: $transactionType)';
  }

  @override
  bool operator ==(covariant GoalTransactionModel other) {
    if (identical(this, other)) return true;

    return other.goalId == goalId &&
        other.amount == amount &&
        other.note == note &&
        other.transactionType == transactionType;
  }

  @override
  int get hashCode {
    return goalId.hashCode ^
        amount.hashCode ^
        note.hashCode ^
        transactionType.hashCode;
  }
}
