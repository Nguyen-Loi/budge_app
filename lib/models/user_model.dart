// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';

class UserModel {
  final String id;
  final String email;
  final String profileUrl;
  final String name;
  final int accountTypeValue;
  final int currencyTypeValue;
  final String? phoneNumber;
  final String? dialCode;
  final DateTime createdDate;
  final DateTime updatedDate;
  UserModel({
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.name,
    required this.accountTypeValue,
    required this.currencyTypeValue,
    this.phoneNumber,
    this.dialCode,
    required this.createdDate,
    required this.updatedDate,
  });

  AccountType get accountType => AccountType.fromValue(accountTypeValue);
  CurrencyType get currencyType => CurrencyType.fromValue(currencyTypeValue);

  UserModel copyWith({
    String? id,
    String? email,
    String? profileUrl,
    String? name,
    int? accountTypeValue,
    int? currencyTypeValue,
    String? phoneNumber,
    String? dialCode,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      name: name ?? this.name,
      accountTypeValue: accountTypeValue ?? this.accountTypeValue,
      currencyTypeValue: currencyTypeValue ?? this.currencyTypeValue,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dialCode: dialCode ?? this.dialCode,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'profileUrl': profileUrl,
      'name': name,
      'accountTypeValue': accountTypeValue,
      'currencyTypeValue': currencyTypeValue,
      'phoneNumber': phoneNumber,
      'dialCode': dialCode,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      profileUrl: map['profileUrl'] as String,
      name: map['name'] as String,
      accountTypeValue: map['accountTypeValue'] as int,
      currencyTypeValue: map['currencyTypeValue'] as int,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      dialCode: map['dialCode'] != null ? map['dialCode'] as String : null,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, profileUrl: $profileUrl, name: $name, accountTypeValue: $accountTypeValue, currencyTypeValue: $currencyTypeValue, phoneNumber: $phoneNumber, dialCode: $dialCode, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.profileUrl == profileUrl &&
      other.name == name &&
      other.accountTypeValue == accountTypeValue &&
      other.currencyTypeValue == currencyTypeValue &&
      other.phoneNumber == phoneNumber &&
      other.dialCode == dialCode &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      profileUrl.hashCode ^
      name.hashCode ^
      accountTypeValue.hashCode ^
      currencyTypeValue.hashCode ^
      phoneNumber.hashCode ^
      dialCode.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
