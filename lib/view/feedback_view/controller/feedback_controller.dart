import 'package:budget_app/data/datasources/apis/feedback_api.dart';
import 'package:budget_app/data/models/feedback_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State classes
class FeedbackState {
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final List<FeedbackModel> feedbacks;
  final FeedbackModel? lastSubmitted;

  FeedbackState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.feedbacks = const [],
    this.lastSubmitted,
  });

  FeedbackState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    List<FeedbackModel>? feedbacks,
    FeedbackModel? lastSubmitted,
    bool clearError = false,
    bool clearLastSubmitted = false,
  }) {
    return FeedbackState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      feedbacks: feedbacks ?? this.feedbacks,
      lastSubmitted:
          clearLastSubmitted ? null : (lastSubmitted ?? this.lastSubmitted),
    );
  }
}

// Provider for feedback controller
final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, FeedbackState>((ref) {
  final feedbackApi = ref.watch(feedbackApiProvider);
  final user = ref.watch(userBaseControllerProvider);
  return FeedbackController(feedbackApi: feedbackApi, user: user, ref: ref);
});

class FeedbackController extends StateNotifier<FeedbackState> {
  final FeedbackApi _feedbackApi;
  final UserModel _user;
  final Ref _ref;

  FeedbackController({
    required FeedbackApi feedbackApi,
    required UserModel user,
    required Ref ref,
  })  : _feedbackApi = feedbackApi,
        _user = user,
        _ref = ref,
        super(FeedbackState());

  Future<void> submitFeedback({
    required String title,
    required String content,
    required int rating,
  }) async {
    String userId = _ref.read(userBaseControllerProvider).id;

    state = state.copyWith(isSubmitting: true, error: null);

    final result = await _feedbackApi.submitFeedback(
      userId: userId,
      title: title,
      content: content,
      rating: rating,
      userEmail: _user.email,
      userName: _user.name,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          error: failure.error,
        );
      },
      (feedback) {
        state = state.copyWith(
          isSubmitting: false,
          lastSubmitted: feedback,
          feedbacks: [feedback, ...state.feedbacks],
        );
      },
    );
  }

  Future<void> loadUserFeedbacks() async {
    String userId = _ref.read(userBaseControllerProvider).id;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final feedbacks = await _feedbackApi.getUserFeedbacks(userId);
      state = state.copyWith(
        isLoading: false,
        feedbacks: feedbacks,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load feedbacks: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearLastSubmitted() {
    state = state.copyWith(clearLastSubmitted: true);
  }
}
