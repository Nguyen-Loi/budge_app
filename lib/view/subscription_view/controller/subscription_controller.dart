import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/data/datasources/apis/subscription_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionControllerProvider = StateNotifierProvider.autoDispose<
    SubscriptionController, SubscriptionPlanEnum?>(
  (ref) => SubscriptionController(ref),
);

class SubscriptionController extends StateNotifier<SubscriptionPlanEnum?> {
  final Ref ref;

  SubscriptionController(this.ref)
      : super(SubscriptionPlanEnum.monthlyPremium) {
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

    final api = ref.read(subscriptionApiProvider);

    final res = await api.purchaseSubscription(
      plan: plan,
    );
    closeLoading();

    res.fold(
      (error) {
        showBDialogInfoError(context, message: error.message);
      },
      (_) {
        logSuccess('Subscription started successfully');
      },
    );
  }
}
