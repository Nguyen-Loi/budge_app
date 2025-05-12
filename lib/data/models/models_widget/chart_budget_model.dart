import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_data.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';

class ChartBudgetModel {
  final String? budgetId;
  final String budgetName;
  final double value;
  final int iconId;
  final int total;
  ChartBudgetModel({
    required this.budgetId,
    required this.budgetName,
    required this.value,
    required this.iconId,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'budgetId': budgetId,
      'budgetName': budgetName,
      'value': value,
      'iconId': iconId,
      'total': total,
    };
  }

  static List<ChartBudgetModel> toList(
      {required List<TransactionCardModel> allTransactionCard,
      required List<TransactionTypeEnum> transactionTypes}) {
    List<ChartBudgetModel> list = [];

    final listInChart = allTransactionCard
        .where((e) => transactionTypes.contains(e.transactionType))
        .toList();

    final groupBudgetId = listInChart.groupBy((e) => e.transaction.budgetId);
    for (var e in groupBudgetId.entries) {
      TransactionCardModel representItem = e.value.first;
      final model = ChartBudgetModel(
          budgetId: representItem.transaction.budgetId,
          budgetName: representItem.transactionName,
          value: 0,
          iconId: representItem.iconId,
          total: e.value
              .fold(0, (old, element) => old + element.transaction.amount));
      list.add(model);
    }

    // Calculate the sum
    int totalSum = list.fold(0, (sum, item) => sum + (item.total).abs());

    // Update each item's `value` based on its percentage of the total sum
    int index = 0;
    for (ChartBudgetModel item in list) {
      if (totalSum > 0) {
        final avgItem = ((item.total / totalSum) * 100).abs();
        list[index] = item.copyWith(value: avgItem);
      } else {
        list.removeAt(index);
      }
      index++;
    }

    return list;
  }

  @override
  String toString() {
    return 'ChartBudgetModel(budgetId: $budgetId, budgetName: $budgetName, value: $value, iconId: $iconId, total: $total)';
  }

  ChartBudgetModel copyWith({
    String? budgetId,
    String? budgetName,
    double? value,
    int? iconId,
    int? total,
  }) {
    return ChartBudgetModel(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      value: value ?? this.value,
      iconId: iconId ?? this.iconId,
      total: total ?? this.total,
    );
  }

  @override
  bool operator ==(covariant ChartBudgetModel other) {
    if (identical(this, other)) return true;

    return other.budgetId == budgetId &&
        other.budgetName == budgetName &&
        other.value == value &&
        other.iconId == iconId &&
        other.total == total;
  }

  @override
  int get hashCode {
    return budgetId.hashCode ^
        budgetName.hashCode ^
        value.hashCode ^
        iconId.hashCode ^
        total.hashCode;
  }
}
