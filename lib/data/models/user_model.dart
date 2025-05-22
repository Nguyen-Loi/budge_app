// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';

class UserModel {
  final String id;
  final String email;
  final String profileUrl;
  final String name;
  final String accountTypeValue;
  final String currencyTypeValue;
  final int balance;
  final PhoneNumber? phoneNumber;
  final String? token;
  final UserRole role;
  final String languageCode;
  final bool isRemindTransactionEveryDate;
  final DateTime createdDate;
  final DateTime updatedDate;
  UserModel({
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.name,
    required this.accountTypeValue,
    required this.currencyTypeValue,
    required this.balance,
    this.phoneNumber,
    this.token,
    required this.languageCode,
    required this.isRemindTransactionEveryDate,
    required this.role,
    required this.createdDate,
    required this.updatedDate,
  });

  bool get roleAds => role == UserRole.normal;
  AccountType get accountType => AccountType.fromValue(accountTypeValue);
  CurrencyType get currencyType => CurrencyType.fromValue(currencyTypeValue);
  String get balanceMoney => balance.toMoneyStr(currencyType: currencyType);

  UserModel copyWith({
    String? id,
    String? email,
    String? profileUrl,
    String? name,
    String? accountTypeValue,
    String? currencyTypeValue,
    int? balance,
    PhoneNumber? phoneNumber,
    String? token,
    UserRole? role,
    String? languageCode,
    bool? isRemindTransactionEveryDate,
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
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      token: token ?? this.token,
      role: role ?? this.role,
      languageCode: languageCode ?? this.languageCode,
      isRemindTransactionEveryDate:
          isRemindTransactionEveryDate ?? this.isRemindTransactionEveryDate,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  factory UserModel.defaultData() {
    final now = DateTime.now();
    return UserModel(
      id: '',
      email: 'guest@example.com"',
      profileUrl:
          'https://icons.veryicon.com/png/o/miscellaneous/youyinzhibo/guest.png',
      name: 'guest',
      accountTypeValue: AccountType.emailAndPassword.value,
      currencyTypeValue: CurrencyType.usd.value,
      balance: 0,
      phoneNumber: null,
      token: null,
      role: UserRole.normal,
      languageCode: LanguageEnum.english.code,
      isRemindTransactionEveryDate: false,
      createdDate: now,
      updatedDate: now,
    );
  }

  Map<String, dynamic> toMap({bool isSqliteFomat = false}) {
    Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'profileUrl': profileUrl,
      'name': name,
      'accountTypeValue': accountTypeValue,
      'currencyTypeValue': currencyTypeValue,
      'balance': balance,
      'phoneNumber': phoneNumber?.toMap(),
      'token': token,
      'role': role.value,
      'languageCode': languageCode,
      'isRemindTransactionEveryDate': isRemindTransactionEveryDate,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
    if (isSqliteFomat) {
      data['isRemindTransactionEveryDate'] =
          isRemindTransactionEveryDate ? 1 : 0;
      data['phoneNumber'] = phoneNumber?.toString();
    }
    return data;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    PhoneNumber? phoneNumber;
    if (map['phoneNumber'] != null) {
      if (map['phoneNumber'] is String) {
        final phoneStr = map['phoneNumber'] as String;
        final reg = RegExp(
            r'PhoneNumber\(phoneNumber: ([^,]+), dialCode: ([^,]+), isoCode: ([^)]+)\)');
        final match = reg.firstMatch(phoneStr);
        if (match != null) {
          phoneNumber = PhoneNumber(
            phoneNumber: match.group(1),
            dialCode: match.group(2),
            isoCode: match.group(3),
          );
        }
      }
      if (map['phoneNumber'] is Map<String, dynamic>) {
        final objectPhone = map['phoneNumber'] as Map<String, dynamic>;
        phoneNumber = PhoneNumber(
          phoneNumber: objectPhone["phoneNumber"],
          dialCode: objectPhone["dialCode"],
          isoCode: objectPhone["isoCode"],
        );
      }
    }
    bool isRemindTransactionEveryDate = true;
    if (map['isRemindTransactionEveryDate'] != null) {
      final value = map['isRemindTransactionEveryDate'];
      if (value is bool) {
        isRemindTransactionEveryDate = value;
      } else if (value is int) {
        isRemindTransactionEveryDate = value == 1;
      }
    }

    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      profileUrl: map['profileUrl'] as String,
      name: map['name'] as String,
      accountTypeValue: map['accountTypeValue'] as String,
      currencyTypeValue: map['currencyTypeValue'] as String,
      balance: map['balance'] as int,
      phoneNumber: phoneNumber,
      token: map['token'] != null ? map['token'] as String : null,
      role: UserRole.fromValue(map['role'] as String? ?? UserRole.normal.value),
      languageCode:
          map['languageCode'] != null ? map['languageCode'] as String : 'en',
      isRemindTransactionEveryDate: isRemindTransactionEveryDate,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, profileUrl: $profileUrl, name: $name, accountTypeValue: $accountTypeValue, currencyTypeValue: $currencyTypeValue, balance: $balance, phoneNumber: $phoneNumber, token: $token, languageCode: $languageCode, isRemindTransactionEveryDate: $isRemindTransactionEveryDate, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.profileUrl == profileUrl &&
        other.name == name &&
        other.accountTypeValue == accountTypeValue &&
        other.currencyTypeValue == currencyTypeValue &&
        other.balance == balance &&
        other.phoneNumber == phoneNumber &&
        other.token == token &&
        other.role == role &&
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
        balance.hashCode ^
        phoneNumber.hashCode ^
        token.hashCode ^
        role.hashCode ^
        languageCode.hashCode ^
        isRemindTransactionEveryDate.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode;
  }
}

extension PhoneUserModel on PhoneNumber? {
  Map<String, String>? toMap() {
    final phone = this!;
    return {
      "phoneNumber": phone.phoneNumber ?? "",
      "dialCode": phone.dialCode ?? "",
      "isoCode": phone.isoCode ?? "",
    };
  }
}
