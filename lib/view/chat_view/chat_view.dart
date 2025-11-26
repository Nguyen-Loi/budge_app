import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
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

class _ChatViewState extends ConsumerState<ChatView>
    with TickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late ScrollController _scrollController;
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScaleAnimation;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sendButtonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _sendButtonController,
      curve: Curves.easeInOut,
    ));

    _textEditingController.addListener(_onTextChanged);
    super.initState();
  }

  void _onTextChanged() {
    if (_textEditingController.text.trim().isNotEmpty) {
      _sendButtonController.forward();
    } else {
      _sendButtonController.reverse();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(child: _listChat()),
            _buildInputArea(context).responsiveCenter(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    AppLocalizations loc = context.loc;
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          gapW12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText.b1(
                'ViBot',
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              Consumer(builder: (context, ref, child) {
                final user = ref.watch(userBaseControllerProvider);
                return BText.caption(
                  "${loc.hello}, ${user.nameDisplay(loc)}!",
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                );
              }),
            ],
          ),
        ],
      ),
      actions: [
        Consumer(builder: (context, ref, child) {
          final hasContent = ref.watch(chatBaseControllerProvider).isNotEmpty;
          return hasContent
              ? IconButton(
                  icon: Icon(IconManager.removeChat),
                  onPressed: () {
                    BDialogInfo(
                            dialogInfoType: BDialogInfoType.warning,
                            title: context.loc.removeChatTitle,
                            message: context.loc.removeChatMessage)
                        .presentAction(
                      context,
                      onSubmit: () {
                        ref
                            .read(chatControllerProvider.notifier)
                            .removeSession(context);
                      },
                    );
                  },
                )
              : SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: context.loc.chatHint,
                  hintStyle: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            gapW12,
            AnimatedBuilder(
              animation: _sendButtonController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sendButtonScaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _textEditingController.text.trim().isNotEmpty
                            ? [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ]
                            : [
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                              ],
                      ),
                      boxShadow: _textEditingController.text.trim().isNotEmpty
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(100),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: IconButton(
                      iconSize: 24,
                      onPressed: _send,
                      tooltip: context.loc.send,
                      icon: Icon(
                        IconManager.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listChat() {
    List<ChatModel> list = ref.watch(chatBaseControllerProvider).toList();
    list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    bool isTyping = ref.watch(chatControllerProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withAlpha(200),
          ],
        ),
      ),
      child: ListView(
        controller: _scrollController,
        reverse: true,
        padding: const EdgeInsets.all(16),
        children: [
          if (isTyping)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const ChatRowTypingItem(),
            ),
          ...list.asMap().entries.map((entry) {
            final index = entry.key;
            final chat = entry.value;
            return Container(
              margin: EdgeInsets.only(
                bottom: index == list.length - 1 ? 24 : 16,
              ),
              child: ChatRowItem(chatModel: chat),
            );
          }),
          // Welcome message
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: const ChatRowStart(),
          ),
        ],
      ).responsiveCenter(width: SizeConstants.tablet),
    );
  }

  void _send() async {
    String content = _textEditingController.text.trim();
    if (content.isEmpty) return;

    _textEditingController.clear();

    // Animate send button
    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });

    // Auto-scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    await ref
        .read(chatControllerProvider.notifier)
        .sendMessage(context, message: content);
  }
}
