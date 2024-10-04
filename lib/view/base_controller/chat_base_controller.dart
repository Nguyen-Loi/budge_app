import 'package:budget_app/apis/chat_api.dart';

import 'package:budget_app/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatBaseControllerProvider =
    StateNotifierProvider<ChatBaseController, List<ChatModel>>((ref) {
  final chatApi = ref.watch(chatAPIProvider);
  return ChatBaseController(chatApi: chatApi);
});

class ChatBaseController extends StateNotifier<List<ChatModel>> {
  ChatBaseController({required ChatApi chatApi})
      : _chatApi = chatApi,
        super([]);

  final ChatApi _chatApi;

  Future<void> init() async {
    final list = await _chatApi.fetchASC();
    state = list;
  }

  List<ChatModel> get chats => state;

  void addChat(ChatModel model) {
    state = [...state, model];
  }
}
