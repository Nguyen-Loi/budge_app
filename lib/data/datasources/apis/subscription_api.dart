import 'dart:async';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/services/subscription_pricing.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/models/subscription_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fpdart/fpdart.dart';

class PurchaseResponse {
  final PurchaseStatus result;
  final String? message;
  final PurchaseDetails? purchaseDetails;

  const PurchaseResponse({
    required this.result,
    this.message,
    this.purchaseDetails,
  });
}

final subscriptionApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final uid = ref.watch(uidControllerProvider);
  final userDb = ref.watch(userApiProvider);
  return SubscriptionApi(db: db, uid: uid, userDb: userDb);
});

abstract class ISubscriptionApi {
  Future<void> updateSubscription(SubscriptionModel subscription);

  // In-app purchase methods
  Future<bool> initialize();
  Future<List<ProductDetails>> getProducts(CurrencyType currency);
  FutureEitherVoid purchaseSubscription({
    required UserModel user,
    required SubscriptionPlanEnum plan,
  });
  Future<List<PurchaseDetails>> restorePurchases(UserModel user);
  Future<void> cancelSubscription(UserModel user);
  Stream<PurchaseResponse> get purchaseStream;
}

class SubscriptionApi implements ISubscriptionApi {
  final FirebaseFirestore _db;
  final String _uid;
  final UserApi _userDb;

  // In-app purchase instance
  static final InAppPurchase _instance = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static final StreamController<PurchaseResponse> _purchaseController =
      StreamController<PurchaseResponse>.broadcast();

  SubscriptionApi({
    required FirebaseFirestore db,
    required String uid,
    required UserApi userDb,
  })  : _db = db,
        _uid = uid,
        _userDb = userDb;

  @override
  Stream<PurchaseResponse> get purchaseStream => _purchaseController.stream;

  @override
  Future<bool> initialize() async {
    try {
      final available = await _instance.isAvailable();
      if (!available) {
        logError('In-app purchases not available');
        return false;
      }

      // Listen for purchase updates
      _subscription = _instance.purchaseStream.listen(
        _handlePurchaseUpdate,
        onError: (error) {
          logError('Purchase stream error: $error');
          _purchaseController.add(PurchaseResponse(
            result: PurchaseStatus.error,
            message: error.toString(),
          ));
        },
      );

      logInfo('In-app purchase service initialized successfully');
      return true;
    } catch (e, stackTrace) {
      logError('Failed to initialize in-app purchase service: $e',
          stackTrace: stackTrace);
      return false;
    }
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _processPurchase(purchaseDetails);
    }
  }

  Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    switch (purchaseDetails.status) {
      case PurchaseStatus.purchased:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          purchaseDetails: purchaseDetails,
          message: 'Purchase completed successfully',
        ));
        break;
      case PurchaseStatus.error:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          message: purchaseDetails.error?.message ?? 'Unknown error',
        ));
        break;
      case PurchaseStatus.canceled:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          message: 'Purchase cancelled by user',
        ));
        break;
      case PurchaseStatus.pending:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          message: 'Purchase is pending',
        ));
        break;
      case PurchaseStatus.restored:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          purchaseDetails: purchaseDetails,
          message: 'Purchase restored successfully',
        ));
        break;
    }

    // Complete the purchase
    if (purchaseDetails.pendingCompletePurchase) {
      _instance.completePurchase(purchaseDetails);
      await _logPurchase(
        purchase: purchaseDetails,
        plan: SubscriptionPlanEnum.baseOnProductId(purchaseDetails.productID),
      );
    }
  }

  Future<void> _logPurchase(
      {required PurchaseDetails purchase,
      required SubscriptionPlanEnum plan}) async {
    final now = DateTime.now();
    final expiryDate = now.add(Duration(days: plan.value));
    UserModel user = await _userDb.getUserById(_uid);

    // Create subscription model for database
    final subscription = SubscriptionModel(
      id: GenId.subscription(),
      userId: user.id,
      purchaseStatus: purchase.status,
      subscriptionPlan: plan,
      amount: plan.amountDependsOnCurrency(user.currency),
      currency: user.currency.code,
      productId: purchase.productID,
      transactionId: purchase.purchaseID,
      purchaseToken: purchase.verificationData.serverVerificationData,
      transactionDate: now,
      expiryDate: expiryDate,
      metadata: {
        'isTrial': true,
        'trialDuration': 7,
      },
    );

    await _newSubscription(subscription);

    // Update user model
    if (purchase.status == PurchaseStatus.purchased) {
      final updatedUser = user.withPlan(
        plan: plan,
        expiryDate: expiryDate,
        newUserRole: UserRoleEnum.premium,
      );
      await _userDb.updateUser(user: updatedUser);
    }

    logInfo('Subscription activated successfully for user: ${user.id}');
  }

  Future<void> _newSubscription(SubscriptionModel subscription) {
    return _db
        .collection(FirestorePath.subscriptions(uid: _uid))
        .doc(subscription.id)
        .set(subscription.toMap());
  }

  @override
  Future<void> updateSubscription(SubscriptionModel subscription) async {
    try {
      await _db
          .collection(FirestorePath.subscriptions(uid: _uid))
          .doc(subscription.id)
          .update(subscription.toMap());
    } catch (e, stackTrace) {
      logError('Failed to update subscription: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<ProductDetails>> getProducts(CurrencyType currency) async {
    try {
      final monthlyProductId = SubscriptionPricing.getProductId(
          SubscriptionPlanEnum.monthly, currency);
      final yearlyProductId = SubscriptionPricing.getProductId(
          SubscriptionPlanEnum.yearly, currency);

      final productIds = {monthlyProductId, yearlyProductId};

      final response = await _instance.queryProductDetails(productIds);

      if (response.error != null) {
        logError('Failed to query products: ${response.error}');
        return [];
      }

      logInfo('Retrieved ${response.productDetails.length} products');
      return response.productDetails;
    } catch (e, stackTrace) {
      logError('Failed to get products: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  FutureEitherVoid purchaseSubscription({
    required UserModel user,
    required SubscriptionPlanEnum plan,
  }) async {
    try {
      final productId = SubscriptionPricing.getProductId(plan, user.currency);
      final products = await getProducts(user.currency);
      final product = products.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw 'Product not found: $productId',
      );

      final purchaseParam = PurchaseParam(productDetails: product);

      // Log purchase attempt
      logInfo(
          'Starting subscription purchase: $productId for user: ${user.id}');

      final success =
          await _instance.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        throw 'Purchase failed for product: $productId';
      }

      return right(null);
    } catch (e, stackTrace) {
      logError('Failed to purchase subscription: $e', stackTrace: stackTrace);
      return left(Failure(message: 'Failed to purchase subscription: $e'));
    }
  }

  @override
  Future<List<PurchaseDetails>> restorePurchases(UserModel user) async {
    try {
      logInfo('Restoring purchases for user: ${user.id}');
      await _instance.restorePurchases();

      // The restored purchases will come through the purchase stream
      // For now, return empty list as the actual restoration is handled by the stream
      return [];
    } catch (e, stackTrace) {
      logError('Failed to restore purchases: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> cancelSubscription(UserModel user) async {
    try {
      // Log cancellation - we'll just log a message since we don't have
      // a specific cancellation transaction structure
      logInfo('Subscription cancellation requested for user: ${user.id}');

      // In a real implementation, you would call the platform-specific
      // cancellation APIs here or update the subscription status in Firestore
    } catch (e, stackTrace) {
      logError('Failed to cancel subscription: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Clean up resources
  void dispose() {
    _subscription?.cancel();
    _purchaseController.close();
  }
}
