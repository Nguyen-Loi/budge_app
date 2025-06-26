import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/models/feedback_model.dart';

abstract class FeedbackRepository {
  FutureEither<FeedbackModel> submitFeedback({
    required String userId,
    required String title,
    required String content,
    required int rating,
    String? userEmail,
    String? userName,
  });

  Future<List<FeedbackModel>> getFeedbacksByEmail(String email);

  Future<List<FeedbackModel>> getUserFeedbacks(String userId);
}
