import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatRowItem extends StatelessWidget {
  const ChatRowItem({super.key, required this.chatModel, this.item});

  final ChatModel chatModel;
  final Widget Function(String message)? item;

  @override
  Widget build(BuildContext context) {
    bool isUser = chatModel.roleType == RoleChatEnum.user;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isUser)
          SizedBox(
            width: MediaQuery.of(context).size.width / 8,
          ),
        if (!isUser) ...[
          SvgPicture.asset(
            SvgAssets.iconBotApp,
            width: 32,
            height: 32,
          ),
          gapW8,
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? 16 : 0),
                topRight: Radius.circular(isUser ? 0 : 16),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
              color: isUser
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).disabledColor,
            ),
            child: item?.call(chatModel.message) ?? _showText(isUser),
          ),
        ),
        if (!isUser)
          SizedBox(
            width: MediaQuery.of(context).size.width / 8,
          )
      ],
    );
  }

  Widget _showText(bool isUser) {
    return isUser
        ? BText(
            chatModel.message,
          )
        : Markdown(
            padding: EdgeInsets.zero,
            data: chatModel.message,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
  }
}
