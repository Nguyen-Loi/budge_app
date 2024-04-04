import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/models/goal_transaction_model.dart';

enum StatusGoal { start, progress, almostDone, complete }

class GoalModel {
  final String userId;
  final String name;
  final int iconId;
  final int currentAmount;
  final int limit;
  final List<GoalTransactionModel> transactions;
  final DateTime createdDate;
  final DateTime updatedDate;

  GoalModel({
    required this.userId,
    required this.name,
    required this.iconId,
    required this.currentAmount,
    required this.limit,
    required this.createdDate,
    required this.updatedDate,
    required this.transactions,
  });

  StatusGoal get status {
    if (currentAmount <= limit / 4) {
      return StatusGoal.start;
    } else if (currentAmount <= limit / 1.5) {
      return StatusGoal.progress;
    } else if (currentAmount < limit) {
      return StatusGoal.almostDone;
    } else {
      return StatusGoal.complete;
    }
  }

  bool get isUrgent => name=='_'; 

  GoalModel copyWith({
    String? userId,
    String? name,
    int? iconId,
    int? currentAmount,
    int? limit,
    CurrencyType? currencyType,
    List<GoalTransactionModel>? transactions,
  }) {
    return GoalModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
      currentAmount: currentAmount ?? this.currentAmount,
      limit: limit ?? this.limit,
      transactions: transactions ?? this.transactions,
      createdDate: createdDate,
      updatedDate: updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'iconId': iconId,
      'currentAmount': currentAmount,
      'limit': limit,
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'createdDate': createdDate,
      'updatedDate': updatedDate
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      iconId: map['iconId'] as int,
      currentAmount: map['currentAmount'] as int,
      limit: map['limit'] as int,
      transactions: List<GoalTransactionModel>.from(
        (map['listTransaction'] as List<GoalTransactionModel>)
            .map<GoalTransactionModel>(
          (x) => GoalTransactionModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdDate: map['createdDate'] as DateTime,
      updatedDate: map['updatedDate'] as DateTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalModel.fromJson(String source) =>
      GoalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GoalModel(userId: $userId, name: $name, iconId: $iconId, currentAmount: $currentAmount, limit: $limit, listTransaction: $transactions)';
  }

  @override
  bool operator ==(covariant GoalModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.name == name &&
        other.iconId == iconId &&
        other.currentAmount == currentAmount &&
        other.limit == limit &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        iconId.hashCode ^
        currentAmount.hashCode ^
        limit.hashCode ^
        transactions.hashCode;
  }
}
