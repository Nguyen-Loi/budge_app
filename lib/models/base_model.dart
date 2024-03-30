import 'package:budget_app/common/methods.dart';
import 'package:budget_app/constants/field_constants.dart';

class BaseModel {
  BaseModel(this.data);
  final Map<String, dynamic> data;
  String get id => Methods.getString(data, FieldConstants.id);
  DateTime get createdAt => Methods.getDateTime(data, FieldConstants.createdAt)!;
  DateTime get updatedAt => Methods.getDateTime(data, FieldConstants.updatedAt)!;
}
