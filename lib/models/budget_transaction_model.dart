import 'package:budget_app/common/methods.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/models/base_model.dart';

class BudgetTransactionModel extends BaseModel {
  BudgetTransactionModel(Map<String, dynamic> data) : super(data);
  int get amount => Methods.getInt(data, FieldConstants.amount);
  String get budgetId => Methods.getString(data, FieldConstants.budgetId);
  String get description => Methods.getString(data, FieldConstants.description);
  TransactionType get transactionType => TransactionType.fromValue(
      Methods.getInt(data, FieldConstants.transactionType));
}
