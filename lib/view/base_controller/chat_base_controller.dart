import 'package:budget_app/data/datasources/apis/chat_api.dart';

import 'package:budget_app/data/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatBaseControllerProvider =
    NotifierProvider<ChatBaseController, List<ChatModel>>(
        ChatBaseController.new);

class ChatBaseController extends Notifier<List<ChatModel>> {
  @override
  List<ChatModel> build() {
    return [];
  }

  Future<void> init() async {
    final list = await ref.read(chatAPIProvider).fetchASC();
    state = list;
  }

  List<ChatModel> get chats => state;

  void addChat(ChatModel model) {
    state = [...state, model];
  }
}
