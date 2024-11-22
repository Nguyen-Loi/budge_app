import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/chat_model.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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

  List<Content> get basePrompt {
    PackageInfo packageInfo = _ref.read(packageInfoBaseControllerProvider);
    TextPart intro =
        TextPart('Tôi là ViBot, tôi chỉ cần trả lời ý chinh ngắn gọn');
    TextPart appInfo = TextPart(
        'Thông tin ứng dụng: \nTên ứng dụng: ${packageInfo.appName} \nPhiên bản: ${packageInfo.version} \nBuild: ${packageInfo.buildNumber}');
    TextPart admin = TextPart(
        'Thông tin admin: \nEmail: hongloi123123@gmail.com, \nSố điện thoại: 0898066957');
    TextPart notes =
        TextPart('Nếu gặp câu hỏi tiếp theo, bạn hãy trả lời theo ý chính');
    final userContent = Content(RoleChatEnum.user.value, [notes]);
    final botContent =
        Content(RoleChatEnum.gemini.value, [intro, appInfo, admin]);
    return [botContent, userContent];
  }

  FutureEither<ChatModel> sendMessage(
      {required List<ChatModel> history}) async {
    DateTime now = DateTime.now();
    final currentUserChat = history.last;

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: '0',
      generationConfig: GenerationConfig(
        topP: 0.9,
        maxOutputTokens: 300,
        temperature: 0.8,
        responseMimeType: 'text/plain',
      ),
    );

    // Sort in ascending order
    history.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    final content = history
        .map((e) => Content(e.roleTypeValue, [TextPart(e.message)]))
        .toList();
    content.insertAll(content.length - 1, basePrompt);

    try {
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
      list.add(currentUserChat);
      if (response.text != null) {
        list.add(geminiChat);
      }
      bool writeSuccess = await _writeToDB(list);

      if (!writeSuccess) {
        return left(Failure(message: 'Check your internet connection'));
      }
      if (response.text == null) {
        return left(Failure(message: 'An error occurred, contact support'));
      }
      return right(geminiChat);
    } on InvalidApiKey {
      return left(Failure(
          message:
              'This feature is under maintenance, please try again later'));
    } catch (e) {
      return left(Failure(message: 'An error occurred, contact support'));
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
