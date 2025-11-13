import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/repositories/feedback_repository.dart';
import 'package:budget_app/data/models/feedback_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final feedbackApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return FeedbackApi(db: db);
});

class FeedbackApi extends FeedbackRepository {
  final FirebaseFirestore _db;

  FeedbackApi({required FirebaseFirestore db}) : _db = db;

  @override
  FutureEither<FeedbackModel> submitFeedback({
    required String userId,
    required String title,
    required String content,
    required int rating,
    String? userEmail,
    String? userName,
  }) async {
    try {
      final now = DateTime.now();

      final feedback = FeedbackModel(
        id: GenId.feedback(),
        userId: userId,
        title: title,
        content: content,
        rating: rating,
        userEmail: userEmail,
        userName: userName,
        createdDate: now,
        updatedDate: now,
      );

        _db
          .collection(FirestorePath.feedbacks())
          .doc(feedback.id)
          .customSet(feedback.toMap());

      return right(feedback);
    } catch (e) {
      logError('Error submitting feedback: ${e.toString()}');
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<List<FeedbackModel>> getFeedbacksByEmail(String email) async {
    try {
      final querySnapshot = await _db
          .collection(FirestorePath.feedbacks())
          .where('userEmail', isEqualTo: email)
          .orderBy('createdDate', descending: true)
          .mapModel<FeedbackModel>(
            modelFrom: FeedbackModel.fromMap,
            modelTo: (model) => model.toMap(),
          )
          .get();

      return querySnapshot.toList();
    } catch (e) {
      logError('Error getting feedbacks: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<List<FeedbackModel>> getUserFeedbacks(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(FirestorePath.feedbacks())
          .where('userId', isEqualTo: userId)
          .orderBy('createdDate', descending: true)
          .mapModel<FeedbackModel>(
            modelFrom: FeedbackModel.fromMap,
            modelTo: (model) => model.toMap(),
          )
          .get();

      return querySnapshot.toList();
    } catch (e) {
      logError('Error getting user feedbacks: ${e.toString()}');
      return [];
    }
  }
}
