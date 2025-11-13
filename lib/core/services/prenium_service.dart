import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to manage prenium features and restrictions
class PreniumService {
  static const int _maxFreeBudgets = 3;
  static const int _maxFreeTransactionsPerMonth = 50;

  final Ref ref;

  PreniumService(this.ref);

  /// Check if user has prenium access
  bool get isPrenium {
    bool isUserPrenium =
        ref.watch(userBaseControllerProvider.select((user) => user.isPrenium));
    return isUserPrenium;
  }

  /// Check if user can create more budgets
  bool canCreateBudget(int currentBudgetCount) {
    if (isPrenium) return true;
    return currentBudgetCount < _maxFreeBudgets;
  }

  /// Check if user can add more transactions this month
  bool canAddTransaction(int transactionsThisMonth) {
    if (isPrenium) return true;
    return transactionsThisMonth < _maxFreeTransactionsPerMonth;
  }

  /// Check if user can access advanced reports
  bool get canAccessAdvancedReports => isPrenium;

  /// Check if user can export data
  bool get canExportData => isPrenium;

  /// Check if user should see ads (opposite of prenium)
  bool get shouldShowAds => !isPrenium;

  /// Get remaining free budgets
  int getRemainingFreeBudgets(int currentBudgetCount) {
    if (isPrenium) return -1; // Unlimited
    return (_maxFreeBudgets - currentBudgetCount).clamp(0, _maxFreeBudgets);
  }

  /// Get remaining free transactions for this month
  int getRemainingFreeTransactions(int transactionsThisMonth) {
    if (isPrenium) return -1; // Unlimited
    return (_maxFreeTransactionsPerMonth - transactionsThisMonth)
        .clamp(0, _maxFreeTransactionsPerMonth);
  }

  /// Get prenium features list
  List<PreniumFeature> get preniumFeatures => [
        PreniumFeature(
          name: "Unlimited Budgets",
          description: "Create as many budgets as you need",
          isEnabled: isPrenium,
        ),
        PreniumFeature(
          name: "Unlimited Transactions",
          description: "Add unlimited transactions per month",
          isEnabled: isPrenium,
        ),
        PreniumFeature(
          name: "Advanced Reports",
          description: "Detailed analytics and insights",
          isEnabled: isPrenium,
        ),
        PreniumFeature(
          name: "Data Export",
          description: "Export your data in multiple formats",
          isEnabled: isPrenium,
        ),
        PreniumFeature(
          name: "No Ads",
          description: "Enjoy an ad-free experience",
          isEnabled: isPrenium,
        ),
        PreniumFeature(
          name: "Priority Support",
          description: "Get priority customer support",
          isEnabled: isPrenium,
        ),
      ];
}

class PreniumFeature {
  final String name;
  final String description;
  final bool isEnabled;

  const PreniumFeature({
    required this.name,
    required this.description,
    required this.isEnabled,
  });
}

/// Provider for PreniumService
final preniumServiceProvider = Provider<PreniumService>((ref) {
  return PreniumService(ref);
});

/// Convenient providers for common prenium checks
final canCreateBudgetProvider = Provider.family<bool, int>((ref, currentCount) {
  final preniumService = ref.watch(preniumServiceProvider);
  return preniumService.canCreateBudget(currentCount);
});

final canAddTransactionProvider =
    Provider.family<bool, int>((ref, transactionsThisMonth) {
  final preniumService = ref.watch(preniumServiceProvider);
  return preniumService.canAddTransaction(transactionsThisMonth);
});

final shouldShowAdsProvider = Provider<bool>((ref) {
  final preniumService = ref.watch(preniumServiceProvider);
  return preniumService.shouldShowAds;
});

final preniumFeaturesProvider = Provider<List<PreniumFeature>>((ref) {
  final preniumService = ref.watch(preniumServiceProvider);
  return preniumService.preniumFeatures;
});
