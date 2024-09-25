import 'package:budget_app/core/b_file_storage.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class BExcel {
  static FutureEither<String> generatedReport(
    BuildContext context, {
    required DateTimeRange dateTimeRange,
    required List<BudgetTransactionsModel> list,
  }) async {
    try {
      final xcel.Workbook workbook = xcel.Workbook();
      final xcel.Worksheet sheet = workbook.worksheets[0];

      final valueItemStyle = xcel.CellStyle(workbook);
      valueItemStyle.borders.all.lineStyle = xcel.LineStyle.thin;

      final headerStyle = xcel.CellStyle(workbook);
      headerStyle.borders.all.lineStyle = xcel.LineStyle.thin;
      headerStyle.hAlign = xcel.HAlignType.center;

      int rowIndex = 1;
      sheet.getRangeByIndex(rowIndex, 1)
        ..setText(context.loc.pBudgetInformationFromDateToEndDate(
            dateTimeRange.end.toFormatDate(),
            dateTimeRange.start.toFormatDate()))
        ..cellStyle.bold = true;

      rowIndex += 2;
      sheet.getRangeByIndex(rowIndex, 1)
        ..setText(context.loc.budgetSummary)
        ..cellStyle.bold = true;
      // infomation budgets
      int budgetNameColIndex = 2;
      int budgetAmountColIndex = 3;
      int budgetLimitColIndex = 4;
      int budgetDurationColIndex = 5;
      int budgetTypeColIndex = 6;

      // Header
      sheet.getRangeByIndex(rowIndex, budgetNameColIndex)
        ..setText(context.loc.budget)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, budgetAmountColIndex)
        ..setText(context.loc.currentValue)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, budgetLimitColIndex)
        ..setText(context.loc.limit)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, budgetDurationColIndex)
        ..setText(context.loc.duration)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, budgetTypeColIndex)
        ..setText(context.loc.type)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;

      rowIndex++;
      // Value
      for (var e in list) {
        final budget = e.budget;
        sheet.getRangeByIndex(rowIndex, budgetNameColIndex)
          ..cellStyle = valueItemStyle
          ..setText(budget.name);
        sheet.getRangeByIndex(rowIndex, budgetAmountColIndex)
          ..cellStyle = valueItemStyle
          ..setText(budget.currentAmount.toMoneyStr());
        sheet.getRangeByIndex(rowIndex, budgetLimitColIndex)
          ..cellStyle = valueItemStyle
          ..setText(budget.limit.toString());
        sheet.getRangeByIndex(rowIndex, budgetDurationColIndex)
          ..cellStyle = valueItemStyle
          ..setText(
              '${budget.startDate.toFormatDate()} - ${budget.endDate.toFormatDate()}');
        sheet.getRangeByIndex(rowIndex, budgetTypeColIndex)
          ..cellStyle = valueItemStyle
          ..setText(budget.budgetType.content(context));

        rowIndex++;
      }

      // Information transactions
      int tranBudgetNameColIndex = 2;
      int tranAmountColIndex = 3;
      int tranDateColIndex = 4;
      int tranCommentsColIndex = 5;
      rowIndex++;
      sheet.getRangeByIndex(rowIndex, 1)
        ..setText(context.loc.transactions)
        ..cellStyle.bold = true;

      // Header
      sheet.getRangeByIndex(rowIndex, tranBudgetNameColIndex)
        ..setText(context.loc.budgets)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, tranAmountColIndex)
        ..setText(context.loc.value)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, tranDateColIndex)
        ..setText(context.loc.transactionDate)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, tranCommentsColIndex)
        ..setText(context.loc.note)
        ..cellStyle = headerStyle
        ..cellStyle.bold = true;
      rowIndex++;

      // Value
      for (var e in list) {
        final budget = e.budget;
        for (var transaction in e.transactions) {
          sheet.getRangeByIndex(rowIndex, tranBudgetNameColIndex)
            ..cellStyle = valueItemStyle
            ..setText(budget.name);
          sheet.getRangeByIndex(rowIndex, tranAmountColIndex)
            ..cellStyle = valueItemStyle
            ..setText(transaction.amount.toMoneyStr());
          sheet.getRangeByIndex(rowIndex, tranDateColIndex)
            ..cellStyle = valueItemStyle
            ..setText(transaction.transactionDate.toFormatDate());
          sheet.getRangeByIndex(rowIndex, tranCommentsColIndex)
            ..cellStyle = valueItemStyle
            ..setText(transaction.note);
          rowIndex++;
        }
      }

      // Summary
      rowIndex++;
      final allTransactions = list.expand((e) => e.transactions).toList();
      final totalIncome = allTransactions
          .where((e) => e.transactionType.budgetType == BudgetTypeEnum.income)
          .map((e) => e.amount)
          .fold(0, (a, b) => a + b);
      final totalExpense = allTransactions
          .where((e) => e.transactionType.budgetType == BudgetTypeEnum.expense)
          .map((e) => e.amount)
          .fold(0, (a, b) => a + b);

      int summaryLabelColIndex = 5;
      int summaryValueColIndex = 6;
      sheet.getRangeByIndex(rowIndex, summaryLabelColIndex)
        ..setText(context.loc.totalIncome)
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, summaryValueColIndex)
        ..setText(totalIncome.toMoneyStr())
        ..cellStyle.bold = true
        ..cellStyle.fontColor = '#28a745';

      rowIndex++;

      sheet.getRangeByIndex(rowIndex, summaryLabelColIndex)
        ..setText(context.loc.totalExpense)
        ..cellStyle.bold = true;
      sheet.getRangeByIndex(rowIndex, summaryValueColIndex)
        ..setText(totalExpense.abs().toMoneyStr())
        ..cellStyle.bold = true
        ..cellStyle.fontColor = '#dc3545';

      // Set default
      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);
      sheet.autoFitColumn(3);
      sheet.autoFitColumn(4);
      sheet.autoFitColumn(5);
      final List<int> bytes = workbook.saveAsStream();
      final fileName =
          '${context.loc.budget}_${dateTimeRange.start.toFormatDate()}_${dateTimeRange.end.toFormatDate()}.xlsx';
      final file = await BFileStorage.writeCounter(bytes, fileName);
      workbook.dispose();
      return right(file.path);
    } on UnsupportedError catch (e) {
      return left(Failure(message: e.toString(), error: e.toString()));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
