import 'package:budget_app/core/b_file_storage.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class BExcel {
  static FutureEither<String> generatedReport(
      {required DateTimeRange dateTimeRange,
      required List<BudgetTransactionsModel> list,
      required UserModel user}) async {
    try {
      final xcel.Workbook workbook = xcel.Workbook();
      final xcel.Worksheet sheet = workbook.worksheets[0];
      int rowIndex = 1;
      sheet.getRangeByIndex(rowIndex, 1).setText(
          "Thông tin ngân sách của ${user.name} từ ngày ${dateTimeRange.start.toFormatDate()} đến ${dateTimeRange.end.toFormatDate()}");

      rowIndex += 2;
      sheet.getRangeByIndex(rowIndex, 1).setText('Budget summary');
      // infomation budgets
      int budgetNameColIndex = 2;
      int budgetAmountColIndex = 3;
      int budgetLimitColIndex = 4;
      int budgetTypeColIndex = 5;
      int budgetDurationColIndex = 6;

      for (var e in list) {
        final budget = e.budget;
        sheet
            .getRangeByIndex(rowIndex, budgetNameColIndex)
            .setText(budget.name);
        sheet
            .getRangeByIndex(rowIndex, budgetAmountColIndex)
            .setText(budget.currentAmount.toString());
        sheet
            .getRangeByIndex(rowIndex, budgetLimitColIndex)
            .setText(budget.limit.toString());
        sheet
            .getRangeByIndex(rowIndex, budgetTypeColIndex)
            .setText(budget.budgetType.name);
        sheet.getRangeByIndex(rowIndex, budgetDurationColIndex).setText(
            '${budget.startDate.toFormatDate()} - ${budget.endDate.toFormatDate()}');
        rowIndex++;
      }

      // Information transactions
      int tranBudgetNameColIndex = 2;
      int tranAmountColIndex = 3;
      int tranDateColIndex = 4;
      int tranCommentsColIndex = 5;
      rowIndex++;
      sheet.getRangeByIndex(rowIndex, 1).setText('Transactions');
      for (var e in list) {
        final budget = e.budget;
        for (var transaction in e.transactions) {
          sheet
              .getRangeByIndex(rowIndex, tranBudgetNameColIndex)
              .setText(budget.name);
          sheet
              .getRangeByIndex(rowIndex, tranAmountColIndex)
              .setText(transaction.amount.toString());
          sheet
              .getRangeByIndex(rowIndex, tranDateColIndex)
              .setText(transaction.transactionDate.toFormatDate());
          sheet
              .getRangeByIndex(rowIndex, tranCommentsColIndex)
              .setText(transaction.note);
          rowIndex++;
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      final fileName =
          'Budget_${dateTimeRange.start.toFormatDate()}_${dateTimeRange.end.toFormatDate()}.xlsx';
      final file = await BFileStorage.writeCounter(bytes.toString(), fileName);
      workbook.dispose();
      return right(file.path);
    } on UnsupportedError catch (e) {
      return left(Failure(message: e.toString(), error: e.toString()));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
