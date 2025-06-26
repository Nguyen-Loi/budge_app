import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/data/models/feedback_model.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/feedback_view/controller/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackView extends ConsumerStatefulWidget {
  const FeedbackView({super.key});

  @override
  ConsumerState<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends ConsumerState<FeedbackView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _rating = 5;
  String? _lastSubmittedId;
  String? _lastErrorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedbackControllerProvider.notifier).loadUserFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes for side effects
    ref.listen<FeedbackState>(feedbackControllerProvider, (previous, next) {
      // Handle error state
      if (next.error != null && next.error != _lastErrorMessage) {
        _lastErrorMessage = next.error;
        showSnackBarError(context, _lastErrorMessage ?? 'An error occurred');
        ref.read(feedbackControllerProvider.notifier).clearError();
      }

      // Handle success state
      if (next.lastSubmitted != null &&
          next.lastSubmitted!.id != _lastSubmittedId) {
        _lastSubmittedId = next.lastSubmitted!.id;
        ref.read(feedbackControllerProvider.notifier).clearLastSubmitted();
        _resetForm();
        showSnackBar(context, context.loc.feedbackSuccess);
      }
    });

    return BaseView(
      title: context.loc.feedback,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildFeedbackForm(),
                        gapH24,
                        _buildMyFeedbackSection(),
                        gapH16, // Extra bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.3),
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.feedback_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  gapW16,
                  Expanded(child: BText.h3(context.loc.submitFeedback)),
                ],
              ),
              gapH16,
              BText(
                context.loc.submitFeedbackDesc,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              gapH24,
              _buildRatingSection(),
              gapH16,
              _buildTitleField(),
              gapH16,
              _buildContentField(),
              gapH24,
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText.b1(
            context.loc.ratingRequired,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          gapH12,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                bool isSelected = index < _rating;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: AnimatedScale(
                      scale: isSelected ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: _iconRating(isSelected, size: 32),
                    ),
                  ),
                );
              }),
            ),
          ),
          gapH8,
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: BText.caption(
                _getRatingText(_rating),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    AppLocalizations loc = context.loc;
    switch (rating) {
      case 1:
        return loc.rate1Desc;
      case 2:
        return loc.rate2Desc;
      case 3:
        return loc.rate3Desc;
      case 4:
        return loc.rate4Desc;
      case 5:
        return loc.rate5Desc;
      default:
        return '';
    }
  }

  Widget _buildTitleField() {
    AppLocalizations loc = context.loc;
    return BFormFieldText(
      _titleController,
      label: loc.titleRequired,
      hint: loc.feedbackTitleHint,
      validator: (value) => value.validateNotNull(context),
      maxLines: 1,
      prefixIcon: Icons.title,
    );
  }

  Widget _buildContentField() {
    AppLocalizations loc = context.loc;
    return BFormFieldText(
      _contentController,
      label: loc.feedbackRequired,
      hint: loc.feedbackDescHint,
      validator: (value) => value.validateNotNull(context),
      maxLines: 5,
      prefixIcon: Icons.message,
    );
  }

  Widget _buildSubmitButton() {
    AppLocalizations loc = context.loc;
    return Consumer(
      builder: (context, ref, child) {
        final feedbackState = ref.watch(feedbackControllerProvider);
        final isSubmitting = feedbackState.isSubmitting;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isSubmitting
                ? LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: !isSubmitting
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            width: double.infinity,
            child: BButton(
              onPressed: isSubmitting ? null : _submitFeedback,
              title: isSubmitting ? loc.submitting : loc.submitFeedback,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyFeedbackSection() {
    AppLocalizations loc = context.loc;
    return Consumer(
      builder: (context, ref, child) {
        final feedbackState = ref.watch(feedbackControllerProvider);
        final feedbacks = feedbackState.feedbacks;
        final isLoading = feedbackState.isLoading;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .shadow
                    .withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        IconManager.history,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    gapW12,
                    Expanded(child: BText.h3(loc.myFeedback)),
                    if (isLoading)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
                gapH16,
                if (feedbacks.isEmpty && !isLoading)
                  _buildEmptyState(loc)
                else
                  ...feedbacks.map((feedback) => _buildFeedbackItem(feedback)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconManager.feedbackEmpty,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          gapH16,
          BText(
            loc.noFeedbackYet,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(FeedbackModel feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context)
                .colorScheme
                .surfaceContainer
                .withValues(alpha: 0.3),
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BText.b1(
                  feedback.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              gapW8,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    bool isFilled = index < feedback.rating;
                    return _iconRating(isFilled, size: 14);
                  }),
                ),
              ),
            ],
          ),
          gapH12,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainer
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: BText(
              feedback.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gapH8,
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              gapW4,
              BText.caption(
                _formatDate(feedback.createdDate),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconRating(bool isFilled, {double size = 16}) {
    return Icon(
      IconManager.rating,
      size: size,
      color: isFilled ? Colors.amber : Theme.of(context).colorScheme.outline,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Dismiss the keyboard before submitting
      FocusScope.of(context).unfocus();

      try {
        ref.read(feedbackControllerProvider.notifier).submitFeedback(
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              rating: _rating,
            );
      } catch (e) {
        showSnackBarError(
            context, 'Failed to submit feedback: ${e.toString()}');
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _rating = 5;
    });
    _lastSubmittedId = null;
    _lastErrorMessage = null;
  }
}
