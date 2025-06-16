import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
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
  late Animation<Color?> _sendButtonColorAnimation;
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

    _sendButtonColorAnimation = ColorTween(
      begin: Colors.grey,
      end: ColorManager.primaryBlue,
    ).animate(_sendButtonController);

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
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              Consumer(builder: (context, ref, child) {
                final user = ref.watch(userBaseControllerProvider);
                return BText.caption(
                  "${context.loc.hello}, ${user.name}!",
                  color: Theme.of(context).colorScheme.primary,
                );
              }),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: _showHelpDialog,
        ),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: context.loc.chatHint,
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
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
                                    .withOpacity(0.3),
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
    bool isTyping =
        ref.watch(chatControllerProvider.select((state) => state.isTyping));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.95),
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            gapW8,
            BText.b1("Chat Help"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BText("Try these examples:", fontWeight: FontWeight.bold),
            gapH12,
            _buildHelpExample("💰", "Lunch 50k"),
            _buildHelpExample("📝", "Add note: bought sandwich"),
            _buildHelpExample("✏️", "Edit amount to 40k"),
            _buildHelpExample("🗑️", "Delete last transaction"),
            _buildHelpExample("📊", "Show my budget summary"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: BText("Got it!"),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpExample(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          BText(emoji),
          gapW8,
          Expanded(
            child: BText.caption(
              text,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
