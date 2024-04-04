import 'dart:convert';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';

class UserModel {
  final String userId;
  final String email;
  final String profileUrl;
  final String name;
  final AccountType accountType;
  final CurrencyType currencyType;
  final DateTime createdDate;
  final DateTime updatedDate;

  UserModel({
    required this.userId,
    required this.email,
    required this.profileUrl,
    required this.name,
    required this.accountType,
    required this.currencyType,
    required this.createdDate,
    required this.updatedDate,
  });

  UserModel copyWith({
    String? userId,
    String? email,
    String? password,
    String? profileUrl,
    String? name,
    AccountType? accountType,
    CurrencyType? currencyType,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      currencyType: currencyType ?? this.currencyType,
      createdDate: createdDate,
      updatedDate: updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'profileUrl': profileUrl,
      'name': name,
      'accountType': AccountType.fromValue(accountType.value),
      'createdDate': createdDate,
      'updatedDate': updatedDate
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      email: map['email'] as String,
      profileUrl: map['profileUrl'] as String,
      name: map['name'] as String,
      accountType: AccountType.fromValue(map['accountType'] as int),
      currencyType: CurrencyType.fromValue(map['currencyType'] as int),
      createdDate: map['createdDate'] as DateTime,
      updatedDate: map['updatedDate'] as DateTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, profileUrl: $profileUrl, name: $name, accountType: $accountType)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.email == email &&
        other.profileUrl == profileUrl &&
        other.name == name &&
        other.accountType == accountType;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        profileUrl.hashCode ^
        name.hashCode ^
        accountType.hashCode;
  }
}
