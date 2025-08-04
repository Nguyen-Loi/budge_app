import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/data/datasources/apis/subscription_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final subscriptionControllerProvider =
    StateNotifierProvider.autoDispose<SubscriptionController, ProductDetails?>(
  (ref) => SubscriptionController(ref),
);

final productsSubscriptionFutureControllerProvider =
    FutureProvider.autoDispose<List<ProductDetails>>((ref) async {
  final api = ref.read(subscriptionApiProvider);
  return await api.getProducts();
});

class SubscriptionController extends StateNotifier<ProductDetails?> {
  final Ref ref;

  SubscriptionController(this.ref) : super(null) {
    _initializeService();
  }

  SubscriptionPlanEnum? get currentPlan {
    if (state == null) return null;
    return SubscriptionPlanEnum.fromProductId(state!.id);
  }

  Future<void> _initializeService() async {
    final api = ref.read(subscriptionApiProvider);
    await api.initialize();
  }

  void updateProduct(ProductDetails product) {
    state = product;
  }

  Stream<PurchaseResponse> get purchaseStream {
    final api = ref.read(subscriptionApiProvider);
    return api.purchaseStream;
  }

  Future<void> startSubscription(BuildContext context,
      {required ProductDetails product}) async {
    final closeLoading = showLoading(context: context);

    final api = ref.read(subscriptionApiProvider);

    final res = await api.purchaseSubscription(
      product: product,
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
