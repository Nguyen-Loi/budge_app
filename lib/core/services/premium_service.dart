import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to manage premium features and restrictions
class PremiumService {
  static const int _maxFreeBudgets = 3;
  static const int _maxFreeTransactionsPerMonth = 50;

  final Ref ref;

  PremiumService(this.ref);

  /// Check if user has premium access
  bool get isPremium {
    bool isUserPremium =
        ref.watch(userBaseControllerProvider.select((user) => user.isPremium));
    return isUserPremium;
  }

  /// Check if user can create more budgets
  bool canCreateBudget(int currentBudgetCount) {
    if (isPremium) return true;
    return currentBudgetCount < _maxFreeBudgets;
  }

  /// Check if user can add more transactions this month
  bool canAddTransaction(int transactionsThisMonth) {
    if (isPremium) return true;
    return transactionsThisMonth < _maxFreeTransactionsPerMonth;
  }

  /// Check if user can access advanced reports
  bool get canAccessAdvancedReports => isPremium;

  /// Check if user can export data
  bool get canExportData => isPremium;

  /// Check if user should see ads (opposite of premium)
  bool get shouldShowAds => !isPremium;

  /// Get remaining free budgets
  int getRemainingFreeBudgets(int currentBudgetCount) {
    if (isPremium) return -1; // Unlimited
    return (_maxFreeBudgets - currentBudgetCount).clamp(0, _maxFreeBudgets);
  }

  /// Get remaining free transactions for this month
  int getRemainingFreeTransactions(int transactionsThisMonth) {
    if (isPremium) return -1; // Unlimited
    return (_maxFreeTransactionsPerMonth - transactionsThisMonth)
        .clamp(0, _maxFreeTransactionsPerMonth);
  }

  /// Get premium features list
  List<PremiumFeature> get premiumFeatures => [
        PremiumFeature(
          name: "Unlimited Budgets",
          description: "Create as many budgets as you need",
          isEnabled: isPremium,
        ),
        PremiumFeature(
          name: "Unlimited Transactions",
          description: "Add unlimited transactions per month",
          isEnabled: isPremium,
        ),
        PremiumFeature(
          name: "Advanced Reports",
          description: "Detailed analytics and insights",
          isEnabled: isPremium,
        ),
        PremiumFeature(
          name: "Data Export",
          description: "Export your data in multiple formats",
          isEnabled: isPremium,
        ),
        PremiumFeature(
          name: "No Ads",
          description: "Enjoy an ad-free experience",
          isEnabled: isPremium,
        ),
        PremiumFeature(
          name: "Priority Support",
          description: "Get priority customer support",
          isEnabled: isPremium,
        ),
      ];
}

class PremiumFeature {
  final String name;
  final String description;
  final bool isEnabled;

  const PremiumFeature({
    required this.name,
    required this.description,
    required this.isEnabled,
  });
}

/// Provider for PremiumService
final premiumServiceProvider = Provider<PremiumService>((ref) {
  return PremiumService(ref);
});

/// Convenient providers for common premium checks
final canCreateBudgetProvider = Provider.family<bool, int>((ref, currentCount) {
  final premiumService = ref.watch(premiumServiceProvider);
  return premiumService.canCreateBudget(currentCount);
});

final canAddTransactionProvider =
    Provider.family<bool, int>((ref, transactionsThisMonth) {
  final premiumService = ref.watch(premiumServiceProvider);
  return premiumService.canAddTransaction(transactionsThisMonth);
});

final shouldShowAdsProvider = Provider<bool>((ref) {
  final premiumService = ref.watch(premiumServiceProvider);
  return premiumService.shouldShowAds;
});

final premiumFeaturesProvider = Provider<List<PremiumFeature>>((ref) {
  final premiumService = ref.watch(premiumServiceProvider);
  return premiumService.premiumFeatures;
});
