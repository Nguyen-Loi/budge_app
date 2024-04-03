import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:budget_app/models/budget_transaction_model.dart';

enum StatusBudget { safe, warning, danger }

class BudgetModel {
  final String id;
  final String userId;
  final String name;
  final int iconId;
  final int currentAmount;
  final int limit;
  final List<BudgetTransactionModel> transactions;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdDate;
  final DateTime updatedDate;
  BudgetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.iconId,
    required this.currentAmount,
    required this.limit,
    required this.transactions,
    required this.startDate,
    required this.endDate,
    required this.createdDate,
    required this.updatedDate,
  });


  StatusBudget get status {
    if (currentAmount <= limit / 2) {
      return StatusBudget.safe;
    } else if (currentAmount < limit) {
      return StatusBudget.warning;
    } else {
      return StatusBudget.danger;
    }
  }

  BudgetModel copyWith({
    String? userId,
    String? name,
    int? iconId,
    int? currentAmount,
    int? limit,
    List<BudgetTransactionModel>? transactions,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return BudgetModel(
      id: id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
      currentAmount: currentAmount ?? this.currentAmount,
      limit: limit ?? this.limit,
      transactions: transactions ?? this.transactions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'iconId': iconId,
      'currentAmount': currentAmount,
      'limit': limit,
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      iconId: map['iconId'] as int,
      currentAmount: map['currentAmount'] as int,
      limit: map['limit'] as int,
      transactions: List<BudgetTransactionModel>.from((map['transactions'] as List<int>).map<BudgetTransactionModel>((x) => BudgetTransactionModel.fromMap(x as Map<String,dynamic>),),),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) => BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(userId: $userId, name: $name, iconId: $iconId, currentAmount: $currentAmount, limit: $limit, transactions: $transactions, startDate: $startDate, endDate: $endDate, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant BudgetModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.name == name &&
      other.iconId == iconId &&
      other.currentAmount == currentAmount &&
      other.limit == limit &&
      listEquals(other.transactions, transactions) &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      name.hashCode ^
      iconId.hashCode ^
      currentAmount.hashCode ^
      limit.hashCode ^
      transactions.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
