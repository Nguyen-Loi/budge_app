import 'dart:async';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:budget_app/core/enums/user_role_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/models/subscription_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fpdart/fpdart.dart';

class PurchaseResponse {
  final PurchaseStatus result;
  final String message;
  final PurchaseDetails? purchaseDetails;

  const PurchaseResponse({
    required this.result,
    required this.message,
    this.purchaseDetails,
  });
}

final subscriptionApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final uid = ref.watch(uidControllerProvider);
  final userDb = ref.watch(userApiProvider);
  return SubscriptionApi(db: db, uid: uid, userDb: userDb, ref: ref);
});

abstract class ISubscriptionApi {
  Future<void> initialize();
  Future<List<ProductDetails>> getProducts();
  FutureEitherVoid purchaseSubscription({
    required ProductDetails product,
  });
  Stream<PurchaseResponse> get purchaseStream;
}

class SubscriptionApi implements ISubscriptionApi {
  final FirebaseFirestore _db;
  final String _uid;
  final UserApi _userDb;
  final Ref _ref;

  // In-app purchase instance
  static final InAppPurchase _instance = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static final StreamController<PurchaseResponse> _purchaseController =
      StreamController<PurchaseResponse>.broadcast();

  SubscriptionApi({
    required FirebaseFirestore db,
    required String uid,
    required UserApi userDb,
    required Ref ref,
  })  : _db = db,
        _uid = uid,
        _userDb = userDb,
        _ref = ref;

  @override
  Stream<PurchaseResponse> get purchaseStream => _purchaseController.stream;

  @override
  Future<void> initialize() async {
    final available = await _instance.isAvailable();
    if (!available) {
      return;
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
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _processPurchase(purchaseDetails);
    }
  }

  Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    AppLocalizations loc = _ref.read(appLocalizationsProvider);
    switch (purchaseDetails.status) {
      case PurchaseStatus.purchased:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          purchaseDetails: purchaseDetails,
          message: loc.purchaseSuccessful,
        ));
        break;
      case PurchaseStatus.error:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          message: loc.purchaseFailed(
              purchaseDetails.error?.message ?? loc.unknownError),
        ));
        break;
      case PurchaseStatus.canceled:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          message: loc.purchaseFailed(loc.purchaseCanceledByUser),
        ));
        break;
      case PurchaseStatus.pending:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          message: loc.purchasePending,
        ));
        break;
      case PurchaseStatus.restored:
        _purchaseController.add(PurchaseResponse(
          result: purchaseDetails.status,
          purchaseDetails: purchaseDetails,
          message: loc.purchaseRestored,
        ));
        break;
    }

    // Complete the purchase
    if (purchaseDetails.pendingCompletePurchase) {
      _instance.completePurchase(purchaseDetails);
      await _logPurchase(
        purchase: purchaseDetails,
      );
      await _updateUserSubscription(purchaseDetails);
    }
  }

  Future<void> _updateUserSubscription(PurchaseDetails purchaseDetails) async {
    final user = _ref.read(userBaseControllerProvider);
    SubscriptionPlanEnum? plan =
        SubscriptionPlanEnum.fromProductId(purchaseDetails.productID);

    DateTime? expiryDate;
    final now = DateTime.now();
    switch (user.subscriptionExpiryDate) {
      case null:
        expiryDate = now.add(Duration(days: plan.durationDays));
        break;
      case DateTime expiry when expiry.isBefore(now):
        expiryDate = now.add(Duration(days: plan.durationDays));
        break;
      case DateTime expiry when expiry.isAfter(now):
        expiryDate = expiry.add(Duration(days: plan.durationDays));
        break;
    }
    final userNewPlan = user.withPlan(
      plan: plan,
      expiryDate: expiryDate,
      newUserRole: UserRoleEnum.premium,
    );
    await _ref
        .read(userBaseControllerProvider.notifier)
        .updateUser(userNewPlan);
  }

  Future<void> _logPurchase({required PurchaseDetails purchase}) async {
    final product = await getProductById(purchase.productID);
    final plan = SubscriptionPlanEnum.fromProductId(purchase.productID);

    final now = DateTime.now();
    final expiryDate = now.add(Duration(days: plan.durationDays));
    UserModel user = await _userDb.getUserById(_uid);

    // Create subscription model for database
    final subscription = SubscriptionModel(
      id: GenId.subscription(),
      userId: user.id,
      purchaseStatus: purchase.status,
      subscriptionPlan: plan,
      amount: product.rawPrice,
      currency: product.currencyCode,
      productId: purchase.productID,
      transactionId: purchase.purchaseID,
      purchaseToken: purchase.verificationData.serverVerificationData,
      transactionDate: now,
      expiryDate: expiryDate,
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
  Future<List<ProductDetails>> getProducts() async {
    final available = await _instance.isAvailable();
    if (!available) {
      throw 'In-app purchase is not available on this device';
    }
    Set<String> productIds =
        SubscriptionPlanEnum.values.map((plan) => plan.productId).toSet();
    final response = await _instance.queryProductDetails(productIds);

    if (response.error != null) {
      logError('Failed to query products: ${response.error}');
      return [];
    }

    logInfo('Retrieved ${response.productDetails.length} products');
    return response.productDetails;
  }

  Future<ProductDetails> getProductById(String productId) async {
    final products = await getProducts();
    return products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Product not found: $productId'),
    );
  }

  @override
  FutureEitherVoid purchaseSubscription({
    required ProductDetails product,
  }) async {
    try {
      final purchaseParam = PurchaseParam(productDetails: product);

      final success =
          await _instance.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        throw 'Purchase failed for product: ${product.id}';
      }

      return right(null);
    } catch (e, stackTrace) {
      logError('Failed to purchase subscription: $e', stackTrace: stackTrace);
      return left(Failure(message: 'Failed to purchase subscription: $e'));
    }
  }

  /// Clean up resources
  void dispose() {
    _subscription?.cancel();
    _purchaseController.close();
  }
}
