import 'package:budget_app/common/widget/b_animated_text.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/chat_view/components/chat_row_item.dart';
import 'package:flutter/material.dart';

class ChatRowTypingItem extends StatelessWidget {
  const ChatRowTypingItem({super.key});

  ChatModel get geminiTyping {
    final now = DateTime.now();
    return ChatModel(
        id: GenId.chat,
        userId: '',
        message: 'Loading',
        roleTypeValue: RoleChatEnum.gemini.value,
        createdDate: now,
        updatedDate: now);
  }

  @override
  Widget build(BuildContext context) {
    return ChatRowItem(
        chatModel: geminiTyping, item: (mess) => BAnimatedText(mess));
  }
}
