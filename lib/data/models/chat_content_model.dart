import 'dart:convert';

import 'package:budget_app/core/enums/role_chat_enum.dart';

class ChatContentModel {
  final RoleChatEnum role;
  final String content;
  ChatContentModel({
    required this.role,
    required this.content,
  });

  ChatContentModel copyWith({
    RoleChatEnum? role,
    String? content,
  }) {
    return ChatContentModel(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role.value,
      'content': content,
    };
  }

  factory ChatContentModel.fromMap(Map<String, dynamic> map) {
    return ChatContentModel(
      role: RoleChatEnum.fromValue(map['role'] as String),
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatContentModel.fromJson(String source) => ChatContentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatModel(role: $role, content: $content)';

  @override
  bool operator ==(covariant ChatContentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.role == role &&
      other.content == content;
  }

  @override
  int get hashCode => role.hashCode ^ content.hashCode;
}


extension ChatContentModelListExtension on List<ChatContentModel> {
  List<Map<String, dynamic>> toMapList() {
    return map((e) => e.toMap()).toList();
  }
}