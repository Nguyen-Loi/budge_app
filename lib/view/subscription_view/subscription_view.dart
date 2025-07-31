import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/services/subscription_pricing.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/theme/app_colors.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/view/subscription_view/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class SubscriptionView extends ConsumerStatefulWidget {
  const SubscriptionView({super.key});

  @override
  ConsumerState<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends ConsumerState<SubscriptionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  StreamSubscription? _purchaseSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    _purchaseSubscription = ref
        .read(subscriptionControllerProvider.notifier)
        .purchaseStream
        .listen((response) {
      if (!mounted) return;
      if (response.result == PurchaseStatus.purchased ||
          response.result == PurchaseStatus.restored) {
        showBDialog(context,
            dialogInfoType: BDialogInfoType.success,
            message: 'Purchase successful');
      } else {
        showBDialog(context,
            dialogInfoType: BDialogInfoType.error,
            message: 'Purchase failed: ${response.message}');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _purchaseSubscription?.cancel();
    ref.read(subscriptionControllerProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: BText.appbar(context.loc.subscription),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderSection(colors),
                    gapH32,
                    _buildBenefitsSection(colors),
                    gapH32,
                    _buildPricingSection(colors),
                    gapH32,
                    _buildActionSection(colors),
                    gapH32
                  ],
                ),
              ).responsiveCenter(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(AppColors colors) {
    AppLocalizations loc = context.loc;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: colors.linearGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.onPrimary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconManager.crown,
              size: 48,
              color: colors.onPrimary,
            ),
          ),
          gapH16,
          BText.h1(
            loc.premium,
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          gapH8,
          BText.b1(
            loc.upgradeToUnlockFeatures,
            color: colors.onPrimary.withAlpha(200),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(AppColors colors) {
    AppLocalizations loc = context.loc;
    final benefits = [
      _BenefitItem(
        icon: IconManager.noAds,
        title: loc.noAds,
        description: loc.enjoyAdFreeExperience,
      ),
      _BenefitItem(
        icon: IconManager.analytics,
        title: loc.advancedReports,
        description: loc.detailedAnalyticsAndInsights,
      ),
      _BenefitItem(
        icon: IconManager.budgetBar,
        title: loc.budgetAnalytics,
        description: loc.comprehensiveBudgetTracking,
      ),
      _BenefitItem(
        icon: IconManager.export,
        title: loc.dataExport,
        description: loc.exportYourDataAnytime,
      ),
      _BenefitItem(
        icon: IconManager.support,
        title: loc.prioritySupport,
        description: loc.getFastPersonalizedHelp,
      ),
      _BenefitItem(
        icon: IconManager.budget,
        title: loc.unlimitedBudgets,
        description: loc.createAsMany,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText.h2(
          loc.premiumBenefits,
          fontWeight: FontWeight.bold,
          color: colors.defaultText,
        ),
        gapH20,
        ...benefits.map((benefit) => _buildBenefitTile(benefit, colors)),
      ],
    );
  }

  Widget _buildBenefitTile(_BenefitItem benefit, AppColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.tileBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.primary.withAlpha(20),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              benefit.icon,
              size: 24,
              color: colors.primary,
            ),
          ),
          gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText.b1(
                  benefit.title,
                  fontWeight: FontWeight.w600,
                  color: colors.defaultText,
                ),
                gapH4,
                BText.b3(
                  benefit.description,
                  color: colors.lightText,
                ),
              ],
            ),
          ),
          Icon(
            IconManager.check,
            color: colors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(AppColors colors) {
    AppLocalizations loc = context.loc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText.h2(
          loc.chooseYourPlan,
          fontWeight: FontWeight.bold,
          color: colors.defaultText,
        ),
        gapH16,
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.tileBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildPlanToggle(
                  title: loc.monthly,
                  plan: SubscriptionPlanEnum.monthly,
                  colors: colors,
                ),
              ),
              Expanded(
                child: _buildPlanToggle(
                  title: loc.yearly,
                  subtitle: loc.saveValuePercent(20),
                  plan: SubscriptionPlanEnum.yearly,
                  colors: colors,
                ),
              ),
            ],
          ),
        ),
        gapH24,
        _buildPricingCard(colors),
      ],
    );
  }

  Widget _buildPlanToggle({
    required String title,
    String? subtitle,
    required SubscriptionPlanEnum plan,
    required AppColors colors,
  }) {
    AppLocalizations loc = context.loc;
    return Consumer(builder: (context, ref, _) {
      final isSelected = ref.watch(subscriptionControllerProvider) == plan;
      return GestureDetector(
        onTap: () {
          ref.read(subscriptionControllerProvider.notifier).updatePlan(plan);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  BText.b1(
                    title,
                    color: isSelected ? colors.onPrimary : colors.defaultText,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    gapH4,
                    BText.caption(
                      subtitle,
                      color: isSelected
                          ? colors.onPrimary.withAlpha(180)
                          : colors.lightText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
              if (plan == SubscriptionPlanEnum.yearly)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BText.caption(
                      loc.mostPopular,
                      color: colors.onSuccess,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPricingCard(AppColors colors) {
    AppLocalizations loc = context.loc;

    return Consumer(builder: (context, ref, _) {
      SubscriptionPlanEnum? plan = ref.watch(subscriptionControllerProvider);

      final textPeriod = plan == null ? "" : plan.content(context);
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withAlpha(10),
              colors.secondary.withAlpha(5),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.primary.withAlpha(30),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BText.h1(
                  plan?.displayPrice(context) ?? "",
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
                gapW8,
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BText.b1(
                    textPeriod,
                    color: colors.lightText,
                  ),
                ),
              ],
            ),
            if (plan == SubscriptionPlanEnum.yearly) ...[
              gapH8,
              BText.b3(
                loc.billedAnnuallyAt(
                    '\$${SubscriptionPricing.getYearlyPrice(CurrencyType.usd).toStringAsFixed(2)}'),
                color: colors.lightText,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildActionSection(AppColors colors) {
    return Consumer(builder: (context, ref, _) {
      SubscriptionPlanEnum? plan = ref.watch(subscriptionControllerProvider);
      final controller = ref.read(subscriptionControllerProvider.notifier);
      return BButton.premium(
          onPressed: () {
            controller.startSubscription(plan!, context);
          },
          enabled: plan != null,
          title: context.loc.upgradeNow);
    });
  }
}

class _BenefitItem {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
