import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/data/datasources/apis/subscription_api.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Subscription controller
class SubscriptionController extends StateNotifier<SubscriptionPlanEnum?> {
  final Ref ref;

  SubscriptionController(this.ref) : super(null) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    final api = ref.read(subscriptionApiProvider);
    await api.initialize();
  }

  void updatePlan(SubscriptionPlanEnum plan) {
    state = plan;
  }

  Stream<PurchaseResponse> get purchaseStream {
    final api = ref.read(subscriptionApiProvider);
    return api.purchaseStream;
  }

  Future<void> startSubscription(
      SubscriptionPlanEnum plan, BuildContext context) async {
    final closeLoading = showLoading(context: context);
    AppLocalizations loc = context.loc;

    final user = ref.read(userBaseControllerProvider);
    final api = ref.read(subscriptionApiProvider);
    
    final res = await api.purchaseSubscription(
      user: user,
      plan: plan,
    );
    closeLoading();
    res.fold((failure) {
      showBDialogInfoError(context, message: loc.failedToStartSubscription(failure.message));
    }, (_) {
      showBDialog(context, dialogInfoType: BDialogInfoType.success, message: "Subscription started successfully");
      final userNewPlan = user.copyWith(
        role: UserRoleEnum.premium,
        subscriptionPlan: plan,
        subscriptionExpiryDate: DateTime.now().add(Duration(days: plan.value)),
      );
      ref.read(userBaseControllerProvider.notifier).updateUser(userNewPlan, withDb: true);
    });
  }

  /// Get available products for current user
  Future<List<ProductDetails>> getAvailableProducts() async {
    final user = ref.read(userBaseControllerProvider);
    final api = ref.read(subscriptionApiProvider);
    return api.getProducts(user.currency);
  }
}

final subscriptionControllerProvider =
    StateNotifierProvider.autoDispose<SubscriptionController, SubscriptionPlanEnum?>(
  (ref) => SubscriptionController(ref),
);
