import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/chat_view/components/chat_row_item.dart';
import 'package:flutter/material.dart';

class ChatRowStart extends StatelessWidget {
  const ChatRowStart({super.key});

  ChatModel geminiTyping(BuildContext context) {
    final now = DateTime.now();
    return ChatModel(
        id: GenId.chat,
        userId: '',
        message: context.loc.viBotHello,
        roleTypeValue: RoleChatEnum.gemini.value,
        createdDate: now,
        updatedDate: now);
  }

  @override
  Widget build(BuildContext context) {
    return ChatRowItem(chatModel: geminiTyping(context));
  }
}
