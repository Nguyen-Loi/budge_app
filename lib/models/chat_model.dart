import 'dart:convert';

import 'package:budget_app/core/enums/role_chat_enum.dart';

class ChatModel {
  final String id;
  final String userId;
  final String message;
  final String roleTypeValue;
  final DateTime createdDate;
  final DateTime updatedDate;
  ChatModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.roleTypeValue,
    required this.createdDate,
    required this.updatedDate,
  });


  RoleChatEnum get roleType =>
      RoleChatEnum.values.firstWhere((e) => e.value == roleTypeValue);

  

  ChatModel copyWith({
    String? id,
    String? userId,
    String? message,
    String? roleTypeValue,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return ChatModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      roleTypeValue: roleTypeValue ?? this.roleTypeValue,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'message': message,
      'roleTypeValue': roleTypeValue,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      message: map['message'] as String,
      roleTypeValue: map['roleTypeValue'] as String,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, userId: $userId, message: $message, roleTypeValue: $roleTypeValue, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.message == message &&
      other.roleTypeValue == roleTypeValue &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      message.hashCode ^
      roleTypeValue.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
