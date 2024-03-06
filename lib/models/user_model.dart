import 'package:budget_app/common/methods.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/models/base_model.dart';

class UserModel extends BaseModel{
  UserModel(Map<String,dynamic> data): super(data);
  String get email =>Methods.getString(data,  FieldConstants.email);
  String get password => Methods.getString(data,  FieldConstants.password);
  String get profileUrl => Methods.getString(data, FieldConstants.profileUrl);
  String get name => Methods.getString(data, FieldConstants.name);
  AccountType get accountType => AccountType.fromValue(Methods.getInt(data, FieldConstants.accountType));

}