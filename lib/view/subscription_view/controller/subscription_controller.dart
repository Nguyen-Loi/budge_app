import 'dart:async';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/data/datasources/apis/subscription_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final subscriptionControllerProvider =
    NotifierProvider.autoDispose<SubscriptionController, ProductDetails?>(
        SubscriptionController.new);

final productsSubscriptionFutureControllerProvider =
    FutureProvider.autoDispose<List<ProductDetails>>((ref) async {
  final api = ref.read(subscriptionApiProvider);
  return await api.getProducts().timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      throw "Connection timeout.";
    },
  );
});

class SubscriptionController extends Notifier<ProductDetails?> {

  @override
  ProductDetails? build() {
    final api = ref.read(subscriptionApiProvider);
    api.initialize();
    return null;
  }

  SubscriptionPlanEnum? get currentPlan {
    if (state == null) return null;
    return SubscriptionPlanEnum.fromProductId(state!.id);
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
