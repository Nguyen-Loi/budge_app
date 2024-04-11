// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';

class UserModel {
  final String id;
  final String email;
  final String profileUrl;
  final String name;
  final int accountValue;
  final int currencyValue;
  final DateTime createdDate;
  final DateTime updatedDate;
  UserModel({
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.name,
    required this.accountValue,
    required this.currencyValue,
    required this.createdDate,
    required this.updatedDate,
  });

  AccountType get accountType => AccountType.fromValue(accountValue);
  CurrencyType get currencyType => CurrencyType.fromValue(currencyValue);

  UserModel copyWith({
    String? id,
    String? email,
    String? profileUrl,
    String? name,
    int? accountValue,
    int? currencyValue,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      name: name ?? this.name,
      accountValue: accountValue ?? this.accountValue,
      currencyValue: currencyValue ?? this.currencyValue,
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
      'accountValue': accountValue,
      'currencyValue': currencyValue,
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
      accountValue: map['accountValue'] as int,
      currencyValue: map['currencyValue'] as int,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, profileUrl: $profileUrl, name: $name, accountValue: $accountValue, currencyValue: $currencyValue, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.profileUrl == profileUrl &&
      other.name == name &&
      other.accountValue == accountValue &&
      other.currencyValue == currencyValue &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      profileUrl.hashCode ^
      name.hashCode ^
      accountValue.hashCode ^
      currencyValue.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
