import 'dart:convert';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/chat_content_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

final chatAPIProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final uid = ref.watch(uidControllerProvider);
  return ChatApi(db: db, uid: uid, ref: ref);
});

abstract class IBotApi {}

class ChatApi implements IBotApi {
  final FirebaseFirestore db;
  final String _uid;
  final Ref _ref;

  ChatApi({
    required this.db,
    required String uid,
    required Ref ref,
  })  : _uid = uid,
        _ref = ref;

  List<ChatContentModel> get basePrompt {
    PackageInfo packageInfo = _ref.read(packageInfoBaseControllerProvider);
    final userModel = _ref.read(userBaseControllerProvider);
    final budgets = _ref.read(budgetBaseControllerProvider);
    List<ChatContentModel> baseContents = [
      ChatContentModel(
          role: RoleChatEnum.user,
          content:
              "You are a helpful assistant. You are designed to assist users with their queries and provide accurate information."
              "Your responses should be concise, informative, and relevant to the user's request."
              "Information about the app smart budget:  ${packageInfo.toString()}, "
              "Info current user: ${userModel.toString()}, "
              "Budgets information: ${budgets.toChatData()}"),
    ];
    return baseContents;
  }

  FutureEither<ChatModel> sendMessage(BuildContext context,
      {required List<ChatModel> history}) async {
    AppLocalizations loc = AppLocalizations.of(context);
    DateTime now = DateTime.now();
    final currentUserChat = history.last;
    final remoteConfig = _ref.read(remoteConfigBaseControllerProvider);
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${remoteConfig.assistantApiKey}',
    };

    history.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    List<ChatContentModel> messages = history
        .map((e) => ChatContentModel(
              role: RoleChatEnum.fromValue(e.roleTypeValue),
              content: e.message,
            ))
        .toList();

    messages.insertAll(messages.length - 1, basePrompt);

    final body = jsonEncode({
      "model": remoteConfig.assistantModel,
      "messages": messages.toMapList(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices']?[0]?['message']?['content'] ?? '';
        if (reply.isEmpty) {
          return left(Failure(message: loc.errorContactSupport));
        }
        ChatModel assistentChat = ChatModel(
          id: GenId.chat,
          userId: _uid,
          message: reply,
          roleTypeValue: RoleChatEnum.assistant.value,
          createdDate: now,
          updatedDate: now,
        );
        // Write to DB
        List<ChatModel> list = [currentUserChat, assistentChat];
        bool writeSuccess = await _writeToDB(list);
        if (!writeSuccess) {
          return left(Failure(message: loc.errorContactSupport));
        }
        return right(assistentChat);
      } else {
        throw Exception(
            'Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logError('ChatApi sendMessage error: $e');
      return left(Failure(message: loc.errorContactSupport));
    }
  }

  Future<List<ChatModel>> fetchASC() {
    return db
        .collection(FirestorePath.chats(uid: _uid))
        .mapModel<ChatModel>(
            modelFrom: ChatModel.fromMap, modelTo: (model) => model.toMap())
        .orderBy('createdDate')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<bool> _writeToDB(List<ChatModel> chats) async {
    try {
      var batch = db.batch();
      chats.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      for (var chat in chats) {
        final docRef =
            db.collection(FirestorePath.chats(uid: _uid)).doc(chat.id);
        batch.set(docRef, chat.toMap());
      }
      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }
}
