import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/chat_view/components/chat_row_item.dart';
import 'package:budget_app/view/chat_view/components/chat_row_start.dart';
import 'package:budget_app/view/chat_view/components/chat_row_typing_item.dart';
import 'package:budget_app/view/chat_view/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  late TextEditingController _textEditingController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Column(
            children: [
              BText.b1(
                'ViBot',
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 4,
              ),
              BText.b3(
                'Online',
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ),
        body: _listChat(),
        bottomSheet: _bottomChat(context),
      ),
    );
  }

  Widget _bottomChat(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: context.loc.chatHint,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          IconButton(
              iconSize: 32,
              onPressed: _send,
              tooltip: context.loc.send,
              icon: Icon(
                IconManager.send,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
    );
  }

  Widget _listChat() {
    List<ChatModel> list = ref.watch(chatBaseControllerProvider).toList();
    list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    bool isTyping = ref.watch(chatControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: ListView(
        reverse: true,
        padding: const EdgeInsets.all(16),
        children: [
          if (isTyping) const ChatRowTypingItem(),
          ...list.map((e) {
            return Column(
              children: [
                ChatRowItem(chatModel: e),
                gapH16,
              ],
            );
          }),
          // Hello in chat
          gapH16,
          const ChatRowStart(),
        ],
      ),
    );
  }

  void _send() async {
    String content = _textEditingController.text.trim();
    _textEditingController.clear();
    await ref
        .read(chatControllerProvider.notifier)
        .sendMessage(context, message: content);
  }
}
