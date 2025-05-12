// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum StatusBudgetProgress { start, progress, almostDone, complete }

enum BudgetStatusTime {
  expired,
  active,
  coming;
}

class BudgetModel {
  final String id;
  final String userId;
  final String name;
  final int iconId;
  final int currentAmount;
  final int limit;
  final String budgetTypeValue;
  final String rangeDateTimeTypeValue;
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
    required this.budgetTypeValue,
    required this.rangeDateTimeTypeValue,
    required this.startDate,
    required this.endDate,
    required this.createdDate,
    required this.updatedDate,
  });

  RangeDateTimeEnum get rangeDateTimeType =>
      RangeDateTimeEnum.fromValue(rangeDateTimeTypeValue);

  BudgetTypeEnum get budgetType => BudgetTypeEnum.fromValue(budgetTypeValue);

  StatusBudgetProgress get status {
    if (currentAmount <= limit / 4) {
      return StatusBudgetProgress.start;
    } else if (currentAmount <= limit / 2) {
      return StatusBudgetProgress.progress;
    } else if (currentAmount < limit) {
      return StatusBudgetProgress.almostDone;
    } else {
      return StatusBudgetProgress.complete;
    }
  }

  BudgetStatusTime get budgetStatusTime {
    if (DateTime.now().isAfter(endDate)) {
      return BudgetStatusTime.expired;
    } else if (DateTime.now().isBefore(startDate)) {
      return BudgetStatusTime.coming;
    } else {
      return BudgetStatusTime.active;
    }
  }

  BudgetModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? iconId,
    int? currentAmount,
    int? limit,
    String? budgetTypeValue,
    String? rangeDateTimeTypeValue,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
      currentAmount: currentAmount ?? this.currentAmount,
      limit: limit ?? this.limit,
      budgetTypeValue: budgetTypeValue ?? this.budgetTypeValue,
      rangeDateTimeTypeValue:
          rangeDateTimeTypeValue ?? this.rangeDateTimeTypeValue,
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
      'budgetTypeValue': budgetTypeValue,
      'rangeDateTimeTypeValue': rangeDateTimeTypeValue,
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
      budgetTypeValue: map['budgetTypeValue'] as String,
      rangeDateTimeTypeValue: map['rangeDateTimeTypeValue'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(id: $id, userId: $userId, name: $name, iconId: $iconId, currentAmount: $currentAmount, limit: $limit, budgetTypeValue: $budgetTypeValue, rangeDateTimeTypeValue: $rangeDateTimeTypeValue, startDate: $startDate, endDate: $endDate, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant BudgetModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.iconId == iconId &&
        other.currentAmount == currentAmount &&
        other.limit == limit &&
        other.budgetTypeValue == budgetTypeValue &&
        other.rangeDateTimeTypeValue == rangeDateTimeTypeValue &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.createdDate == createdDate &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        iconId.hashCode ^
        currentAmount.hashCode ^
        limit.hashCode ^
        budgetTypeValue.hashCode ^
        rangeDateTimeTypeValue.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode;
  }
}

extension BudgetFormatModel on BudgetModel {
  String getReview(BuildContext context,
      {required List<TransactionModel> transactions}) {
    String incomeContent;
    String expenseContent;
    switch (status) {
      case StatusBudgetProgress.start:
        incomeContent = context.loc.startIncome;
        break;
      case StatusBudgetProgress.progress:
        incomeContent = context.loc.processIncome;
        break;
      case StatusBudgetProgress.almostDone:
        incomeContent = context.loc.almostDoneIncome;
        break;
      case StatusBudgetProgress.complete:
        incomeContent = context.loc.completeIncome;
        break;
    }
    final lastestTransaction = transactions.firstOrNull;
    if (lastestTransaction == null) {
      expenseContent = context.loc.startExpense;
    } else {
      expenseContent = context.loc.reviewExpense(
          lastestTransaction.transactionDate.toFormatDate(),
          lastestTransaction.amount.toMoneyStr());
    }

    switch (budgetType) {
      case BudgetTypeEnum.income:
        return incomeContent;
      case BudgetTypeEnum.expense:
        return expenseContent;
    }
  }
}

extension StatusBudgetTimeType on BudgetStatusTime {
  String contentLoc(BuildContext context) {
    switch (this) {
      case BudgetStatusTime.expired:
        return context.loc.expired;
      case BudgetStatusTime.active:
        return context.loc.active;
      case BudgetStatusTime.coming:
        return context.loc.coming;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case BudgetStatusTime.expired:
        return Theme.of(context).colorScheme.error;
      case BudgetStatusTime.active:
        return Theme.of(context).colorScheme.tertiary;
      case BudgetStatusTime.coming:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  String svgAsset(BuildContext context) {
    switch (this) {
      case BudgetStatusTime.expired:
        return SvgAssets.coming;
      case BudgetStatusTime.active:
        return SvgAssets.active;
      case BudgetStatusTime.coming:
        return SvgAssets.coming;
    }
  }
}

extension BudgetWallet on List<BudgetModel> {
  List<BudgetModel> updateValueWallet(
      {required int income, required int expense}) {
    BudgetModel bIncome =
        firstWhere((e) => e.id == TransactionTypeEnum.incomeWallet.value)
            .copyWith(currentAmount: income);
    BudgetModel bExpense =
        firstWhere((e) => e.id == TransactionTypeEnum.expenseWallet.value)
            .copyWith(currentAmount: expense);
    int bIncomeIndex =
        indexWhere((e) => e.id == TransactionTypeEnum.incomeWallet.value);
    int bExpenseIndex =
        indexWhere((e) => e.id == TransactionTypeEnum.expenseWallet.value);
    this[bIncomeIndex] = bIncome;
    this[bExpenseIndex] = bExpense;
    return this;
  }

  List<BudgetModel> withBudgetWallet(
    AppLocalizations loc,
  ) {
    final budgetWalletExist = any((e) =>
        e.id == TransactionTypeEnum.incomeWallet.value ||
        e.id == TransactionTypeEnum.expenseWallet.value);

    if (budgetWalletExist) {
      return this;
    }
    final now = DateTime.now();
    final currentRangeMonth = now.getRangeMonth;
    String incomeValue = TransactionTypeEnum.incomeWallet.value;
    String expenseValue = TransactionTypeEnum.expenseWallet.value;

    BudgetModel budgetBase = BudgetModel(
        id: '0',
        userId: '0',
        name: 'Budget Base',
        iconId: IconManagerData.idMoneyIn,
        currentAmount: 0,
        limit: 0,
        budgetTypeValue: BudgetTypeEnum.income.value,
        rangeDateTimeTypeValue: RangeDateTimeEnum.month.value,
        startDate: currentRangeMonth.start,
        endDate: currentRangeMonth.end,
        createdDate: now,
        updatedDate: now);

    BudgetModel incomeWallet = budgetBase.copyWith(
        id: incomeValue,
        name: TransactionTypeEnum.incomeWallet.contentLoc(loc),
        budgetTypeValue: BudgetTypeEnum.income.value,
        iconId: IconManagerData.idMoneyIn,
        currentAmount: 0);
    BudgetModel expenseWallet = budgetBase.copyWith(
        id: expenseValue,
        name: TransactionTypeEnum.expenseWallet.contentLoc(loc),
        budgetTypeValue: BudgetTypeEnum.expense.value,
        iconId: IconManagerData.idMoneyOut,
        currentAmount: 0);
    add(incomeWallet);
    add(expenseWallet);

    return this;
  }
}
