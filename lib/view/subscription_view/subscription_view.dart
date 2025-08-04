import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/theme/app_colors.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
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
      if (response.result == PurchaseStatus.purchased) {
        final user = ref.read(userBaseControllerProvider);
        String? productId = response.purchaseDetails?.productID;

        if (productId == null) {
          showBDialogInfoError(context,
              message: context.loc.purchaseFailed(
                response.message,
              ));
          return;
        }
        SubscriptionPlanEnum? plan =
            SubscriptionPlanEnum.fromProductId(productId);
        final userNewPlan = user.withPlan(
          plan: plan,
          expiryDate: DateTime.now().add(
            Duration(days: plan.durationDays),
          ),
          newUserRole: UserRoleEnum.premium,
        );
        showBDialog(context,
            dialogInfoType: BDialogInfoType.success, message: response.message);
        ref
            .read(userBaseControllerProvider.notifier)
            .updateUser(userNewPlan, withDb: true);
      } else {
        showBDialog(context,
            dialogInfoType: BDialogInfoType.error, message: response.message);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _purchaseSubscription?.cancel();

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
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(
                    productsSubscriptionFutureControllerProvider.future),
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

    return Consumer(builder: (context, ref, _) {
      return ref.watch(productsSubscriptionFutureControllerProvider).when(
            data: (products) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BText.h2(
                    loc.chooseYourPlan,
                    fontWeight: FontWeight.bold,
                    color: colors.defaultText,
                  ),
                  gapH16,
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: products.map((product) {
                      final plan =
                          SubscriptionPlanEnum.fromProductId(product.id);
                      return SizedBox(
                        width:
                            (MediaQuery.of(context).size.width - 48 - 16) / 2,
                        height: 100,
                        child: _buildPlanToggle(
                          title: plan.content(context),
                          subtitle: product.price,
                          plan: plan,
                          colors: colors,
                          product: product,
                        ),
                      );
                    }).toList(),
                  ),
                  gapH24,
                  _buildPricingCard(colors: colors),
                ],
              );
            },
            error: (error, stack) {
              logError(error.toString(), stackTrace: stack);
              return BText(
                loc.errorLoadingProducts,
                color: colors.error,
                textAlign: TextAlign.center,
              );
            },
            loading: () => Center(child: BStatus.loading()),
          );
    });
  }

  Widget _buildPlanToggle({
    required String title,
    String? subtitle,
    required SubscriptionPlanEnum plan,
    required AppColors colors,
    required ProductDetails product,
  }) {
    AppLocalizations loc = context.loc;

    return Consumer(builder: (context, ref, _) {
      bool isSelected = ref.watch(subscriptionControllerProvider) == product;
      return GestureDetector(
        onTap: () {
          ref
              .read(subscriptionControllerProvider.notifier)
              .updateProduct(product);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colors.onPrimary.withAlpha(200)
                  : colors.primary.withAlpha(30),
              width: 2,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ],
                ],
              ),
              if (plan == SubscriptionPlanEnum.yearlyPremium) ...[
                Positioned(
                  top: -24,
                  right: -24,
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
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPricingCard({required AppColors colors}) {
    AppLocalizations loc = context.loc;

    return Consumer(builder: (context, ref, _) {
      ProductDetails? product = ref.watch(subscriptionControllerProvider);
      SubscriptionPlanEnum? plan =
          ref.read(subscriptionControllerProvider.notifier).currentPlan;

      final textPeriod = plan == null ? "" : plan.content(context);
      if (plan == null) {
        return SizedBox.shrink();
      }
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
                  product?.price ?? '',
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
            if (plan == SubscriptionPlanEnum.yearlyPremium) ...[
              gapH8,
              BText.b3(
                loc.billedAnnuallyAt(
                  product?.price ?? '',
                ),
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
      ProductDetails? product = ref.watch(subscriptionControllerProvider);
      final controller = ref.read(subscriptionControllerProvider.notifier);
      return BButton.premium(
          onPressed: () {
            controller.startSubscription(context, product: product!);
          },
          enabled: product != null,
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
