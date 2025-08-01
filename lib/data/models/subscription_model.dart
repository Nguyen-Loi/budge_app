import 'package:budget_app/core/enums/subscription_plan_enum.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionModel {
  final String id;
  final String userId;
  final PurchaseStatus purchaseStatus;
  final SubscriptionPlanEnum? subscriptionPlan;
  final int amount;
  final String currency;
  final String? productId;
  final String? transactionId;
  final String? purchaseToken;
  final DateTime transactionDate;
  final DateTime? expiryDate;
  final Map<String, dynamic>? metadata;

  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.purchaseStatus,
    this.subscriptionPlan,
    required this.amount,
    required this.currency,
    this.productId,
    this.transactionId,
    this.purchaseToken,
    required this.transactionDate,
    this.expiryDate,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'purchaseStatus': purchaseStatus.name,
      'subscriptionPlan': subscriptionPlan?.name,
      'amount': amount,
      'currency': currency,
      'productId': productId,
      'transactionId': transactionId,
      'purchaseToken': purchaseToken,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'metadata': metadata,
    };
  }

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    PurchaseStatus? purchaseStatus,
    SubscriptionPlanEnum? subscriptionPlan,
    int? amount,
    String? currency,
    String? productId,
    String? transactionId,
    String? purchaseToken,
    DateTime? transactionDate,
    DateTime? expiryDate,
    Map<String, dynamic>? metadata,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      productId: productId ?? this.productId,
      transactionId: transactionId ?? this.transactionId,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      transactionDate: transactionDate ?? this.transactionDate,
      expiryDate: expiryDate ?? this.expiryDate,
      metadata: metadata ?? this.metadata,
    );
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      purchaseStatus: PurchaseStatus.values.firstWhere(
        (e) => e.name == map['purchaseStatus'] as String,
      ),
      subscriptionPlan: map['subscriptionPlan'] as SubscriptionPlanEnum?,
      amount: (map['amount'] as num).toInt(),
      currency: map['currency'] as String,
      productId: map['productId'] as String?,
      transactionId: map['transactionId'] as String?,
      purchaseToken: map['purchaseToken'] as String?,
      transactionDate:
          DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
      expiryDate: map['expiryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'] as int)
          : null,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }
}
