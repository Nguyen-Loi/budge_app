import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

final inAppReviewProvider = Provider<InAppReview>((ref) {
  return InAppReview.instance;
});

final inAppRatingServiceProvider = Provider<InAppRatingService>((ref) {
  return InAppRatingService(ref);
});

class InAppRatingService {
  const InAppRatingService(this.ref);
  final Ref ref;

  InAppReview get _inAppReview => ref.read(inAppReviewProvider);

  SharedUtility get _sharedUtility => ref.read(sharedUtilityProvider);

  Future<void> requestReviewIfNeeded(
      {required int userTransactionCount}) async {
    try {
      if (kIsWeb) {
        return;
      }

      final reviewRequestCount = _sharedUtility.getInAppReviewPromptCount();

      // Use exponential backoff strategy:
      // - 1st request after 5 transactions
      // - 2nd request after 15 total transactions (10 more)
      // - 3rd request after 35 total transactions (20 more)
      bool shouldShowReview = false;

      if (userTransactionCount >= 5 && reviewRequestCount == 0) {
        shouldShowReview = true;
      } else if (userTransactionCount >= 15 && reviewRequestCount == 1) {
        shouldShowReview = true;
      } else if (userTransactionCount >= 35 && reviewRequestCount == 2) {
        shouldShowReview = true;
      }

      if (shouldShowReview) {
        if (await _inAppReview.isAvailable()) {
          await _inAppReview.requestReview();
          await _sharedUtility.incrementInAppReviewPromptCount();

          logInfo(
              'In-app review requested. Count: ${reviewRequestCount + 1}, Transactions: $userTransactionCount');
        }
      }
      logInfo('Review info: ${_reviewInfo()}');
    } catch (e, stackTrace) {
      logError('Error requesting app review: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  Future<void> requestReviewManually(BuildContext context) async {
    try {
      final inAppReview = _inAppReview;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        if (context.mounted) {
          _showThankYouDialog(context);
        }
      }
    } catch (e, stackTrace) {
      logError('Error requesting manual app review: $e',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        BDialogInfo(
          message: context.loc.anErrorUnexpectedOccur,
          dialogInfoType: BDialogInfoType.error,
        ).present(context);
      }
    }
  }

  /// Open app store for review (alternative method)
  Future<void> openStoreForReview(BuildContext context) async {
    try {
      final inAppReview = _inAppReview;
      await inAppReview.openStoreListing();
    } catch (e, stackTrace) {
      logError('Error opening store for review: $e',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        BDialogInfo(
          message: context.loc.anErrorUnexpectedOccur,
          dialogInfoType: BDialogInfoType.error,
        ).present(context);
      }
    }
  }

  void _showThankYouDialog(BuildContext context) {
    BDialogInfo(
      message: context.loc.thankYouYourFeedback,
      dialogInfoType: BDialogInfoType.success,
    ).present(context);
  }

  /// Get debug information about review status
  Map<String, dynamic> _reviewInfo() {
    return {
      'reviewRequestCount': _sharedUtility.getInAppReviewPromptCount(),
      'userTransactionCount': _sharedUtility.getUserTransactionCount(),
      'isWeb': kIsWeb,
    };
  }
}
