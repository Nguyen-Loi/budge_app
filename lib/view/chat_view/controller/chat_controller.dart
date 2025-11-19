import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/chat_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider =
    NotifierProvider.autoDispose<ChatController, bool>(ChatController.new);
class ChatController extends Notifier<bool> {

  late ChatBaseController _chatBaseController;
  late ChatApi _chatApi;
  late String _uid;

    @override
  bool build() {
    _chatBaseController = ref.watch(chatBaseControllerProvider.notifier);
    _chatApi = ref.watch(chatAPIProvider);
    _uid = ref.watch(uidControllerProvider);
   return false;
  }

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

  Future<void> removeSession(BuildContext context) async {
    final closeDialog = showLoading(context: context);
    final res = await _chatApi.removeSession();
    if (res.isLeft() && context.mounted) {
      closeDialog();
      showBDialogInfoError(context, message: res.getLeftMessage);
      return;
    }
    await _chatBaseController.init();
    closeDialog();
  }

}
