import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final chatAPIProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final uid = ref.watch(uidControllerProvider);
  return ChatApi(db: db, uid: uid);
});

abstract class IBotApi {}

class ChatApi implements IBotApi {
  final FirebaseFirestore db;
  final String _uid;

  ChatApi({
    required this.db,
    required String uid,
  }) : _uid = uid;

  String get _apiKey {
    const key = String.fromEnvironment('GEMINI_KEY');
    return key;
  }

  FutureEither<ChatModel> sendMessage(
      {required List<ChatModel> history, required ChatModel userChat}) async {
    DateTime now = DateTime.now();

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );

    // Sort in ascending order
    history.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    final content = history
        .map((e) => Content(e.roleTypeValue, [TextPart(e.message)]))
        .toList();
    GenerateContentResponse response = await model.generateContent(content);

    ChatModel geminiChat = ChatModel(
      id: GenId.chat,
      userId: _uid,
      message: response.text ?? 'An error occurred, contact support',
      roleTypeValue: RoleChatEnum.gemini.value,
      createdDate: now,
      updatedDate: now,
    );

    // Write to DB
    List<ChatModel> list = [];
    list.add(userChat);
    if (response.text != null) {
      list.add(geminiChat);
    }
    bool writeSuccess = await _writeToDB(list);

    if (!writeSuccess) {
      return left(Failure(error: 'Check your internet connection'));
    }
    if (response.text == null) {
      return left(Failure(error: 'An error occurred, contact support'));
    }

    return right(geminiChat);
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
