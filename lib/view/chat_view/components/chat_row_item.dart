import 'package:budget_app/common/widget/b_smart_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRowItem extends ConsumerStatefulWidget {
  const ChatRowItem({super.key, required this.chatModel, this.item});

  final ChatModel chatModel;
  final Widget Function(String message)? item;

  @override
  ConsumerState<ChatRowItem> createState() => _ChatRowItemState();
}

class _ChatRowItemState extends ConsumerState<ChatRowItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUser = widget.chatModel.roleType == RoleChatEnum.user;
    final user = ref.watch(userBaseControllerProvider);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isUser) ...[
                  _buildBotAvatar(context),
                  gapW12,
                ],
                if (isUser)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                  ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isUser ? 20 : 4),
                            topRight: Radius.circular(isUser ? 4 : 20),
                            bottomLeft: const Radius.circular(20),
                            bottomRight: const Radius.circular(20),
                          ),
                          color: isUser
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: widget.item?.call(widget.chatModel.message) ??
                            _showText(isUser),
                      ),
                      gapH4,
                      _buildTimestamp(context, isUser),
                    ],
                  ),
                ),
                if (isUser) ...[
                  gapW12,
                  _buildUserAvatar(user),
                ],
                if (!isUser)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBotAvatar(BuildContext context) {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildUserAvatar(user) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BSmartAvatar(
        data: user.profileUrl,
        size: 20,
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context, bool isUser) {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 0 : 8,
        right: isUser ? 8 : 0,
      ),
      child: BText.caption(
        _formatTime(widget.chatModel.createdDate),
        color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _showText(bool isUser) {
    final textColor = isUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return SelectionArea(
      child: isUser
          ? BText(
              widget.chatModel.message,
              color: textColor,
            )
          : _buildRichMarkdown(textColor),
    );
  }

  Widget _buildRichMarkdown(Color textColor) {
    return Markdown(
      padding: EdgeInsets.zero,
      data: widget.chatModel.message,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          color: textColor,
          fontSize: 14,
          height: 1.4,
        ),
        strong: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        em: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
