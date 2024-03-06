import 'package:budget_app/common/methods.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/models/base_model.dart';

class TransactionCategoryModel extends BaseModel {
  TransactionCategoryModel(Map<String, dynamic> data) : super(data);
  String get name => Methods.getString(data, FieldConstants.name);
  String get icon => Methods.getString(data, FieldConstants.icon);
}
