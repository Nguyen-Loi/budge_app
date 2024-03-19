import 'package:budget_app/common/methods.dart';
import 'package:budget_app/constants/budget_icon_constant.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/models/base_model.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';

class BudgetModel extends BaseModel {
  BudgetModel(Map<String, dynamic> data) : super(data);
  String get userId => Methods.getString(data, FieldConstants.userId);
  String get name => Methods.getString(data, FieldConstants.name);
  int get iconId => Methods.getInt(data, FieldConstants.iconId);
  int get currentAmount => Methods.getInt(data, FieldConstants.currentAmount);
  int get limit => Methods.getInt(data, FieldConstants.limit);

  IconModel get icon => BudgetIconConstant.getIconModel(iconId);
  
  CurrencyType get currencyType =>
      CurrencyType.fromValue(Methods.getInt(data, FieldConstants.currencyType));
  DateTime get startDate =>
      Methods.getDateTime(data, FieldConstants.startDate) ??
      DateTime(1, 1, 1, 1);
  DateTime get endDate =>
      Methods.getDateTime(data, FieldConstants.endDate) ?? DateTime(1, 1, 1, 1);
}
