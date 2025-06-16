import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';

class DefaultBudgetService {
  const DefaultBudgetService._();

  /// Creates default budget list for first-time users
  static List<BudgetModel> createDefaultBudgets({
    required String userId,
    required AppLocalizations localizations,
  }) {
    final now = DateTime.now();
    final endDate = DateTime(9999, 12, 31);

    final defaultBudgets = <BudgetModel>[];

    // Default expense budgets
    final expenseBudgets = [
      _createBudgetData(
        name: localizations.defaultBudgetHousing,
        icon: AppIcons.home,
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'housing',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetFood,
        icon: AppIcons.food,
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'food',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetTransportation,
        icon: AppIcons.transport, 
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'transportation',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetUtilities,
        icon: AppIcons.water, 
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'utilities',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetEntertainment,
        icon: AppIcons.gamepad,
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'entertainment',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetHealthcare,
        icon: AppIcons.heart, 
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'healthcare',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetShopping,
        icon: AppIcons.shopping, 
        budgetType: BudgetTypeEnum.expense,
        localizationKey: 'shopping',
      ),
    ];

    // Default income budgets
    final incomeBudgets = [
      _createBudgetData(
        name: localizations.defaultBudgetSalary,
        icon: AppIcons.briefcase, // Use static constant
        budgetType: BudgetTypeEnum.income,
        localizationKey: 'salary',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetFreelance,
        icon: AppIcons.code, // Use static constant
        budgetType: BudgetTypeEnum.income,
        localizationKey: 'freelance',
      ),
      _createBudgetData(
        name: localizations.defaultBudgetInvestments,
        icon: AppIcons.calculator, // Use static constant
        budgetType: BudgetTypeEnum.income,
        localizationKey: 'investments',
      ),
    ];

    // Create budget models
    for (final budgetData in [...expenseBudgets, ...incomeBudgets]) {
      defaultBudgets.add(
        BudgetModel(
          id: GenId.budget(),
          userId: userId,
          name: budgetData['name'] as String,
          iconName: budgetData['iconName'] as String,
          currentAmount: 0,
          budgetLimit: 0, // All budgets start with 0 limit as specified
          budgetTypeValue: (budgetData['budgetType'] as BudgetTypeEnum).value,
          rangeDateTimeTypeValue: RangeDateTimeEnum.allTime.value,
          startDate: now,
          endDate: endDate,
          createdDate: now,
          updatedDate: now,
        ),
      );
    }

    return defaultBudgets;
  }

  static Map<String, dynamic> _createBudgetData({
    required String name,
    required AppIcons icon,
    required BudgetTypeEnum budgetType,
    required String localizationKey,
  }) {
    return {
      'name': name,
      'iconName': icon.name,
      'budgetType': budgetType,
      'localizationKey': localizationKey,
    };
  }

  /// Check if user needs default budgets (first time setup)
  static bool shouldCreateDefaultBudgets(
    List<BudgetModel> existingBudgets,
    SharedUtility sharedUtility,
  ) {
    if (sharedUtility.areDefaultBudgetsCreated()) {
      return false;
    }

    return existingBudgets.isEmpty;
  }

  /// Gets the default budget name mappings for translation
  static Map<String, String> getDefaultBudgetLocalizations(
      AppLocalizations localizations) {
    return {
      'housing': localizations.defaultBudgetHousing,
      'food': localizations.defaultBudgetFood,
      'transportation': localizations.defaultBudgetTransportation,
      'utilities': localizations.defaultBudgetUtilities,
      'entertainment': localizations.defaultBudgetEntertainment,
      'healthcare': localizations.defaultBudgetHealthcare,
      'shopping': localizations.defaultBudgetShopping,
      'salary': localizations.defaultBudgetSalary,
      'freelance': localizations.defaultBudgetFreelance,
      'investments': localizations.defaultBudgetInvestments,
    };
  }

  /// Gets localization key mapping for default budget names
  static Map<String, String> getDefaultBudgetKeyMapping() {
    return {
      // English names to keys
      'Housing': 'housing',
      'Food & Dining': 'food',
      'Transportation': 'transportation',
      'Utilities': 'utilities',
      'Entertainment': 'entertainment',
      'Healthcare': 'healthcare',
      'Shopping': 'shopping',
      'Salary': 'salary',
      'Freelance': 'freelance',
      'Investments': 'investments',
      // Vietnamese names to keys
      'Nhà ở': 'housing',
      'Ăn uống': 'food',
      'Đi lại': 'transportation',
      'Tiện ích': 'utilities',
      'Giải trí': 'entertainment',
      'Y tế': 'healthcare',
      'Mua sắm': 'shopping',
      'Lương': 'salary',
      'Đầu tư': 'investments',
    };
  }

  /// Updates default budget names to current language
  static List<BudgetModel> updateDefaultBudgetNames(
    List<BudgetModel> budgets,
    AppLocalizations localizations,
  ) {
    final localizedNames = getDefaultBudgetLocalizations(localizations);
    final keyMapping = getDefaultBudgetKeyMapping();

    return budgets.map((budget) {
      final localizationKey = keyMapping[budget.name];
      if (localizationKey != null &&
          localizedNames.containsKey(localizationKey)) {
        final newName = localizedNames[localizationKey]!;
        return budget.copyWith(
          name: newName,
          updatedDate: DateTime.now(),
        );
      }
      return budget;
    }).toList();
  }
}
