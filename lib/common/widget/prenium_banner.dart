import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/theme/app_colors.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreniumBanner extends ConsumerWidget {
  const PreniumBanner({
    super.key,
    this.message = "Upgrade to Prenium for advanced features",
    this.showCloseButton = true,
  });

  final String message;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserPrenium =
        ref.watch(userBaseControllerProvider.select((user) => user.isPrenium));
    final colors = Theme.of(context).extension<AppColors>()!;

    // Don't show banner if user has prenium
    if (isUserPrenium) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withAlpha(20),
            colors.secondary.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.primary.withAlpha(30),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconManager.crown,
              color: colors.primary,
              size: 20,
            ),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText.b1(
                  "Prenium",
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
                gapH4,
                BText.b3(
                  message,
                  color: colors.lightText,
                ),
              ],
            ),
          ),
          gapW12,
          BButton(
            title: "Upgrade",
            onPressed: () => _navigateToSubscription(context),
            size: ButtonSize.small,
          ),
          if (showCloseButton) ...[
            gapW8,
            IconButton(
              onPressed: () => _dismissBanner(context),
              icon: Icon(
                Icons.close,
                size: 16,
                color: colors.lightText,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToSubscription(BuildContext context) {
    Navigator.pushNamed(context, RoutePath.subscription);
  }

  void _dismissBanner(BuildContext context) {
    showBDialog(context,
        dialogInfoType: BDialogInfoType.success,
        message: context.loc.bannerDismissed);
  }
}

class PreniumFeatureGate extends ConsumerWidget {
  const PreniumFeatureGate({
    super.key,
    required this.child,
    this.preniumChild,
    this.featureName = "This feature",
  });

  final Widget child;
  final Widget? preniumChild;
  final String featureName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserPrenium =
        ref.watch(userBaseControllerProvider.select((user) => user.isPrenium));
    final colors = Theme.of(context).extension<AppColors>()!;

    if (isUserPrenium) {
      return child;
    }

    return preniumChild ??
        GestureDetector(
          onTap: () => _showPreniumDialog(context, colors),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: child,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface.withAlpha(100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconManager.crown,
                          color: colors.primary,
                          size: 32,
                        ),
                        gapH8,
                        BText.b1(
                          "Prenium Feature",
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        gapH4,
                        BText.b3(
                          "Tap to upgrade",
                          color: colors.lightText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  void _showPreniumDialog(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              IconManager.crown,
              color: colors.primary,
              size: 24,
            ),
            gapW8,
            const BText.h3("Prenium Feature"),
          ],
        ),
        content: BText(
          "$featureName requires a Prenium subscription. Upgrade now to unlock this and many other advanced features.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: BText(
              "Cancel",
              color: colors.lightText,
            ),
          ),
          BButton(
            title: "Upgrade Now",
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RoutePath.subscription);
            },
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }
}
