import 'dart:convert';

import 'package:budget_app/core/enums/transaction_type_enum.dart';

class BudgetTransactionModel {
  final String budgetId;
  final String amount;
  final String description;
  final TransactionType transactionType;
  final DateTime createdDate;
  final DateTime updatedDate;
  BudgetTransactionModel({
    required this.budgetId,
    required this.amount,
    required this.description,
    required this.transactionType,
    required this.createdDate,
    required this.updatedDate,
  });

 

  BudgetTransactionModel copyWith({
    String? budgetId,
    String? amount,
    String? description,
    TransactionType? transactionType,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return BudgetTransactionModel(
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      transactionType: transactionType ?? this.transactionType,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'budgetId': budgetId,
      'amount': amount,
      'description': description,
      'transactionType': transactionType.value,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory BudgetTransactionModel.fromMap(Map<String, dynamic> map) {
    return BudgetTransactionModel(
      budgetId: map['budgetId'] as String,
      amount: map['amount'] as String,
      description: map['description'] as String,
      transactionType: TransactionType.fromValue(map['transactionType'] as int),
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetTransactionModel.fromJson(String source) => BudgetTransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetTransactionModel(budgetId: $budgetId, amount: $amount, description: $description, transactionType: $transactionType, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant BudgetTransactionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.budgetId == budgetId &&
      other.amount == amount &&
      other.description == description &&
      other.transactionType == transactionType &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return budgetId.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      transactionType.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
