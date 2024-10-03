import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/chat_view/components/chat_row_item.dart';
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
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    super.initState();
  }


  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();

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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _listChat(),
              ),
              _bottomChat(context),
            ],
          ),
        ),
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
              focusNode: _focusNode,
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
    list.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    bool isTyping = ref.watch(chatControllerProvider);

    return ListView(
      reverse: true,
      padding: const EdgeInsets.all(16),
      addAutomaticKeepAlives: true,
      controller: _scrollController,
      children: [
        ...list.map((e) {
          return Column(
            children: [
              ChatRowItem(chatModel: e),
              gapH16,
            ],
          );
        }),
        if (isTyping) const ChatRowTypingItem()
      ],
    );
  }

  void _send() async {
    String content = _textEditingController.text.trim();
    _textEditingController.clear();
    FocusScope.of(context).unfocus();
    await ref
        .read(chatControllerProvider.notifier)
        .sendMessage(context, message: content);
  }
}
