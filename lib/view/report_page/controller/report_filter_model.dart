import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:flutter/material.dart';

class ReportFilterModel {
  final DateTimeRange dateTimeRangePicker;
  final List<BudgetTypeEnum> budgetTypes;
  final List<String> selectedBudgetIds;
  final List<ChartBudgetModel> chartData;
  final List<BudgetTransactionsModel> budgetTransactionsList;
  final bool isLoading;

  ReportFilterModel({
    required this.dateTimeRangePicker,
    required this.budgetTypes,
    required this.selectedBudgetIds,
    required this.chartData,
    required this.budgetTransactionsList,
    this.isLoading = false,
  });

  ReportFilterModel copyWith({
    DateTimeRange? dateTimeRangePicker,
    List<BudgetTypeEnum>? budgetTypes,
    List<String>? selectedBudgetIds,
    List<ChartBudgetModel>? chartData,
    List<BudgetTransactionsModel>? budgetTransactionsList,
    bool? isLoading,
  }) {
    return ReportFilterModel(
      dateTimeRangePicker: dateTimeRangePicker ?? this.dateTimeRangePicker,
      budgetTypes: budgetTypes ?? this.budgetTypes,
      selectedBudgetIds: selectedBudgetIds ?? this.selectedBudgetIds,
      chartData: chartData ?? this.chartData,
      budgetTransactionsList:
          budgetTransactionsList ?? this.budgetTransactionsList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
