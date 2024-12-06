import 'package:budget_app/apis/chat_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider =
    StateNotifierProvider.autoDispose<ChatController, bool>((ref) {
  final chatBaseController = ref.watch(chatBaseControllerProvider.notifier);
  final chatApi = ref.watch(chatAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  return ChatController(
      chatBaseController: chatBaseController, chats: chatApi, uid: uid);
});

class ChatController extends StateNotifier<bool> {
  ChatController(
      {required ChatBaseController chatBaseController,
      required ChatApi chats,
      required String uid})
      : _chatBaseController = chatBaseController,
        _chatApi = chats,
        _uid = uid,
        super(false);
  final ChatBaseController _chatBaseController;
  final ChatApi _chatApi;
  final String _uid;

  // Make is chat related to history
  List<ChatModel> get _recentChats {
    final prompt = _chatBaseController.chats.toList();
    prompt.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return prompt.take(3).toList();
  }

  Future<void> sendMessage(BuildContext context,
      {required String message}) async {
    if (message.isEmpty || state == true) {
      BDialogInfo(
              message: context.loc.dataEmpty,
              dialogInfoType: BDialogInfoType.warning)
          .present(context);
      return;
    }
    final now = DateTime.now();
    final userChat = ChatModel(
        id: GenId.chat,
        userId: _uid,
        message: message,
        roleTypeValue: RoleChatEnum.user.value,
        createdDate: now,
        updatedDate: now);
    state = true;
    _chatBaseController.addChat(userChat);

    final botChat = await _chatApi.sendMessage(context, history: _recentChats);

    state = false;
    botChat.fold(
      (l) => showBDialogInfoError(context, message: l.message),
      (r) => _chatBaseController.addChat(r),
    );
  }
}
