import 'package:budget_app/core/b_file.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
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
      AppLocalizations loc = context.loc;
      final xcel.Workbook workbook = xcel.Workbook();

      // Create multiple sheets
      final xcel.Worksheet overviewSheet = workbook.worksheets[0];
      overviewSheet.name = loc.overview;

      final xcel.Worksheet budgetSheet = workbook.worksheets.add();
      budgetSheet.name = loc.budgetSummary;

      final xcel.Worksheet transactionSheet = workbook.worksheets.add();
      transactionSheet.name = loc.transactions;

      // Create styles
      final styles = _createStyles(workbook);

      // Create Overview Sheet
      _createOverviewSheet(context, overviewSheet, dateTimeRange, list, styles);

      // Create Budget Summary Sheet
      _createBudgetSummarySheet(context, budgetSheet, list, styles);

      // Create Transactions Sheet
      _createTransactionsSheet(context, transactionSheet, list, styles);

      // Auto-fit columns for all sheets
      for (final sheet in [
        overviewSheet,
        budgetSheet,
        transactionSheet,
      ]) {
        for (int i = 1; i <= 8; i++) {
          sheet.autoFitColumn(i);
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      final fileName =
          '${context.loc.budget}_${dateTimeRange.start.toFormatDate()}_${dateTimeRange.end.toFormatDate()}.xlsx';

      workbook.dispose();

      String name = await BFile.download(bytes: bytes, fileName: fileName);
      return right(name);
    } on UnsupportedError catch (e) {
      return left(Failure(message: e.toString(), error: e.toString()));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  static Map<String, xcel.CellStyle> _createStyles(xcel.Workbook workbook) {
    final titleStyle = xcel.CellStyle(workbook);
    titleStyle.bold = true;
    titleStyle.fontSize = 16;
    titleStyle.hAlign = xcel.HAlignType.center;
    titleStyle.fontColor = '#1976D2';
    titleStyle.backColor = '#E3F2FD';

    final headerStyle = xcel.CellStyle(workbook);
    headerStyle.hAlign = xcel.HAlignType.center;
    headerStyle.vAlign = xcel.VAlignType.center;
    headerStyle.bold = true;
    headerStyle.fontSize = 12;
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.backColor = '#2196F3';

    final valueItemStyle = xcel.CellStyle(workbook);
    valueItemStyle.borders.all.lineStyle = xcel.LineStyle.thin;
    valueItemStyle.hAlign = xcel.HAlignType.left;
    valueItemStyle.vAlign = xcel.VAlignType.center;

    final rankStyle = xcel.CellStyle(workbook);
    rankStyle.borders.all.lineStyle = xcel.LineStyle.thin;
    rankStyle.hAlign = xcel.HAlignType.center;
    rankStyle.vAlign = xcel.VAlignType.center;
    rankStyle.bold = true;
    rankStyle.fontSize = 11;

    final positiveStyle = xcel.CellStyle(workbook);
    positiveStyle.borders.all.lineStyle = xcel.LineStyle.thin;
    positiveStyle.fontColor = '#4CAF50';
    positiveStyle.bold = true;

    final negativeStyle = xcel.CellStyle(workbook);
    negativeStyle.borders.all.lineStyle = xcel.LineStyle.thin;
    negativeStyle.fontColor = '#F44336';
    negativeStyle.bold = true;

    final summaryHeaderStyle = xcel.CellStyle(workbook);
    summaryHeaderStyle.hAlign = xcel.HAlignType.center;
    summaryHeaderStyle.bold = true;
    summaryHeaderStyle.fontSize = 14;
    summaryHeaderStyle.fontColor = '#FFFFFF';
    summaryHeaderStyle.backColor = '#FF9800';

    return {
      'title': titleStyle,
      'header': headerStyle,
      'value': valueItemStyle,
      'rank': rankStyle,
      'positive': positiveStyle,
      'negative': negativeStyle,
      'summaryHeader': summaryHeaderStyle,
    };
  }

  static void _createOverviewSheet(
    BuildContext context,
    xcel.Worksheet sheet,
    DateTimeRange dateTimeRange,
    List<BudgetTransactionsModel> list,
    Map<String, xcel.CellStyle> styles,
  ) {
    int rowIndex = 1;
    AppLocalizations loc = context.loc;
    // Title
    sheet.getRangeByName('A1:G1').merge();
    sheet.getRangeByIndex(rowIndex, 1)
      ..setText(
          '📘 ${context.loc.pBudgetInformationFromDateToEndDate(dateTimeRange.start.toFormatDate(), dateTimeRange.end.toFormatDate())}')
      ..cellStyle = styles['title']!;

    rowIndex += 3;

    // Calculate totals
    final overviewTransactions = list.expand((e) => e.transactions).toList();
    final overviewTotalIncome = overviewTransactions
        .where((e) => e.transactionType.budgetType == BudgetTypeEnum.income)
        .map((e) => e.amount)
        .fold(0, (a, b) => a + b);
    final overviewTotalExpense = overviewTransactions
        .where((e) => e.transactionType.budgetType == BudgetTypeEnum.expense)
        .map((e) => e.amount)
        .fold(0, (a, b) => a + b);
    final netIncome = overviewTotalIncome + overviewTotalExpense;

    // Overview cards
    final overviewHeaders = [
      '💰 ${loc.totalIncome}',
      '💸 ${loc.totalExpense}',
      '📈 ${loc.netIncome}',
      '📊 ${loc.totalBudgets}',
      '📝 ${loc.totalTransactions}'
    ];

    final overviewValues = [
      overviewTotalIncome.toMoneyStrContext(context),
      overviewTotalExpense.abs().toMoneyStrContext(context),
      netIncome.toMoneyStrContext(context),
      '${list.length}',
      '${overviewTransactions.length}'
    ];

    for (int i = 0; i < overviewHeaders.length; i++) {
      final col = i + 1;
      sheet.getRangeByIndex(rowIndex, col)
        ..setText(overviewHeaders[i])
        ..cellStyle = styles['header']!;

      final valueStyle = xcel.CellStyle(sheet.workbook);
      valueStyle.borders.all.lineStyle = xcel.LineStyle.thin;
      valueStyle.hAlign = xcel.HAlignType.center;
      valueStyle.bold = true;
      valueStyle.fontSize = 11;
      valueStyle.fontColor = i == 0
          ? '#4CAF50'
          : i == 1
              ? '#F44336'
              : netIncome >= 0
                  ? '#4CAF50'
                  : '#F44336';

      sheet.getRangeByIndex(rowIndex + 1, col)
        ..setText(overviewValues[i])
        ..cellStyle = valueStyle;
    }
  }

  static void _createBudgetSummarySheet(
    BuildContext context,
    xcel.Worksheet sheet,
    List<BudgetTransactionsModel> list,
    Map<String, xcel.CellStyle> styles,
  ) {
    int rowIndex = 1;
    AppLocalizations loc = context.loc;

    // Title
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByIndex(rowIndex, 1)
      ..setText('🏆 ${context.loc.budgetSummary} - ${loc.rankedByActivity}')
      ..cellStyle = styles['summaryHeader']!;

    rowIndex += 2;

    // Sort budgets by transaction count and amount for ranking
    final sortedBudgets = list.toList()
      ..sort((a, b) {
        final aTransCount = a.transactions.length;
        final bTransCount = b.transactions.length;
        if (aTransCount != bTransCount) {
          return bTransCount.compareTo(aTransCount);
        }
        final aAmount =
            a.transactions.fold(0, (sum, t) => sum + t.amount.abs());
        final bAmount =
            b.transactions.fold(0, (sum, t) => sum + t.amount.abs());
        return bAmount.compareTo(aAmount);
      });

    // Headers
    final budgetHeaders = [
      '🏆 Rank',
      '📊 ${loc.budget}',
      '💰 ${loc.currentValue}',
      '🎯 ${loc.limit}',
      '⏰ ${loc.duration}',
      '📈 ${loc.type}',
      '📝 ${loc.transactionCount}',
      '📊 ${loc.utilization}'
    ];

    for (int i = 0; i < budgetHeaders.length; i++) {
      sheet.getRangeByIndex(rowIndex, i + 1)
        ..setText(budgetHeaders[i])
        ..cellStyle = styles['header']!;
    }

    rowIndex++;

    // Budget data
    for (int i = 0; i < sortedBudgets.length; i++) {
      final budgetData = sortedBudgets[i];
      final budget = budgetData.budget;
      final transactionCount = budgetData.transactions.length;
      final utilization = budget.budgetLimit > 0
          ? (budget.currentAmount.abs() / budget.budgetLimit * 100)
              .toStringAsFixed(1)
          : '';

      String rankText = '${i + 1}';
      if (i == 0) {
        rankText = '🥇 $rankText';
      } else if (i == 1) {
        rankText = '🥈 $rankText';
      } else if (i == 2) {
        rankText = '🥉 $rankText';
      }

      sheet.getRangeByIndex(rowIndex, 1)
        ..setText(rankText)
        ..cellStyle = styles['rank']!;

      sheet.getRangeByIndex(rowIndex, 2)
        ..setText(budget.name)
        ..cellStyle = styles['value']!;

      sheet.getRangeByIndex(rowIndex, 3)
        ..setText(budget.currentAmount.toMoneyStrContext(context))
        ..cellStyle = budget.currentAmount >= 0
            ? styles['positive']!
            : styles['negative']!;

      sheet.getRangeByIndex(rowIndex, 4)
        ..setText(budget.budgetLimit > 0
            ? budget.budgetLimit.toMoneyStrContext(context)
            : loc.noLimit)
        ..cellStyle = styles['value']!;

      sheet.getRangeByIndex(rowIndex, 5)
        ..setText(
            '${budget.startDate.toFormatDate()} - ${budget.endDate.toFormatDate()}')
        ..cellStyle = styles['value']!;

      sheet.getRangeByIndex(rowIndex, 6)
        ..setText(
            '${budget.budgetType == BudgetTypeEnum.income ? '💰' : '💸'} ${budget.budgetType.content(context)}')
        ..cellStyle = styles['value']!;

      sheet.getRangeByIndex(rowIndex, 7)
        ..setText('$transactionCount')
        ..cellStyle = styles['value']!;

      sheet.getRangeByIndex(rowIndex, 8)
        ..setText('$utilization%')
        ..cellStyle = styles['value']!;

      rowIndex++;
    }
  }

  static void _createTransactionsSheet(
    BuildContext context,
    xcel.Worksheet sheet,
    List<BudgetTransactionsModel> list,
    Map<String, xcel.CellStyle> styles,
  ) {
    int rowIndex = 1;
    AppLocalizations loc = context.loc;

    // Title
    sheet.getRangeByName('A1:F1').merge();
    sheet.getRangeByIndex(rowIndex, 1)
      ..setText('📝 ${context.loc.transactions} - ${loc.detailedView}')
      ..cellStyle = styles['summaryHeader']!;

    rowIndex += 2;

    // Transaction headers
    final transactionHeaders = [
      '#',
      '📊 ${loc.budgets}',
      '💰 ${loc.value}',
      '📅 ${loc.transactionDate}',
      '📝 ${loc.note}',
      '🏷️ ${loc.type}'
    ];

    for (int i = 0; i < transactionHeaders.length; i++) {
      sheet.getRangeByIndex(rowIndex, i + 1)
        ..setText(transactionHeaders[i])
        ..cellStyle = styles['header']!;
    }

    rowIndex++;

    // Group transactions by budget type
    final incomeTransactions = <Map<String, dynamic>>[];
    final expenseTransactions = <Map<String, dynamic>>[];

    for (var budgetData in list) {
      final budget = budgetData.budget;
      for (var transaction in budgetData.transactions) {
        final transactionInfo = {
          'budget': budget,
          'transaction': transaction,
          'budgetName': budget.name,
          'amount': transaction.amount,
          'date': transaction.transactionDate,
          'note': transaction.note,
          'type': transaction.transactionType.budgetType,
        };

        if (transaction.transactionType.budgetType == BudgetTypeEnum.income) {
          incomeTransactions.add(transactionInfo);
        } else {
          expenseTransactions.add(transactionInfo);
        }
      }
    }

    // Sort transactions by date (newest first)
    incomeTransactions.sort((a, b) => b['date'].compareTo(a['date']));
    expenseTransactions.sort((a, b) => b['date'].compareTo(a['date']));

    int transactionNumber = 1;

    // Income transactions section
    if (incomeTransactions.isNotEmpty) {
      sheet.getRangeByIndex(rowIndex, 1)
        ..setText('💰 ${loc.incomeTransactions.toUpperCase()}')
        ..cellStyle = styles['positive']!;
      rowIndex++;

      for (var transInfo in incomeTransactions) {
        sheet.getRangeByIndex(rowIndex, 1)
          ..setText('$transactionNumber')
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 2)
          ..setText(transInfo['budgetName'])
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 3)
          ..setText((transInfo['amount'] as int).toMoneyStrContext(context))
          ..cellStyle = styles['positive']!;

        sheet.getRangeByIndex(rowIndex, 4)
          ..setText((transInfo['date'] as DateTime).toFormatDate())
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 5)
          ..setText(transInfo['note'])
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 6)
          ..setText('💰 ${loc.income}')
          ..cellStyle = styles['positive']!;

        rowIndex++;
        transactionNumber++;
      }
      rowIndex++;
    }

    // Expense transactions section
    if (expenseTransactions.isNotEmpty) {
      sheet.getRangeByIndex(rowIndex, 1)
        ..setText('💸 ${loc.expenseTransactions.toUpperCase()}')
        ..cellStyle = styles['negative']!;
      rowIndex++;

      for (var transInfo in expenseTransactions) {
        sheet.getRangeByIndex(rowIndex, 1)
          ..setText('$transactionNumber')
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 2)
          ..setText(transInfo['budgetName'])
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 3)
          ..setText((transInfo['amount'] as int).toMoneyStrContext(context))
          ..cellStyle = styles['negative']!;

        sheet.getRangeByIndex(rowIndex, 4)
          ..setText((transInfo['date'] as DateTime).toFormatDate())
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 5)
          ..setText(transInfo['note'])
          ..cellStyle = styles['value']!;

        sheet.getRangeByIndex(rowIndex, 6)
          ..setText('💸 ${loc.expense}')
          ..cellStyle = styles['negative']!;

        rowIndex++;
        transactionNumber++;
      }
    }
  }
}
