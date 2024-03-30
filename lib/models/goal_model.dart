import 'package:budget_app/common/methods.dart';
import 'package:budget_app/common/table_constant.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/models/base_model.dart';
import 'package:budget_app/models/goal_transaction_model.dart';

enum StatusBudget { start, progress, almostDone, complete }

class GoalModel extends BaseModel {
  GoalModel(Map<String, dynamic> data) : super(data);
  static const String strUrgentMain = 'Urgent';
  bool get isUrgent => name == strUrgentMain;

  String get userId => Methods.getString(data, FieldConstants.userId);
  String get name => Methods.getString(data, FieldConstants.name);
  int get iconId => Methods.getInt(data, FieldConstants.iconId);
  int get currentAmount => Methods.getInt(data, FieldConstants.currentAmount);
  int get limit => Methods.getInt(data, FieldConstants.limit);
  List<GoalTransactionModel> get transactions =>
      Methods.getList(data, TableConstant.goalTransaction)
          .map((e) => GoalTransactionModel(e))
          .toList();

  StatusBudget get status {
    if (currentAmount <= limit / 4) {
      return StatusBudget.start;
    } else if (currentAmount <= limit / 1.5) {
      return StatusBudget.progress;
    } else if (currentAmount < limit) {
      return StatusBudget.almostDone;
    } else {
      return StatusBudget.complete;
    }
  }

  CurrencyType get currencyType =>
      CurrencyType.fromValue(Methods.getInt(data, FieldConstants.currencyType));
}
