import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ViBotService {
  static const Map<String, List<String>> _categoryKeywords = {
    'food': [
      // English
      'lunch', 'dinner', 'breakfast', 'coffee', 'restaurant', 'food', 'eat',
      'meal', 'snack', 'drink',
      // Vietnamese
      'ăn', 'uống', 'cơm', 'phở', 'cafe', 'cà phê', 'trưa', 'sáng', 'tối',
      'nhà hàng', 'quán', 'đồ ăn'
    ],
    'transportation': [
      // English
      'taxi', 'bus', 'train', 'gas', 'fuel', 'parking', 'uber', 'grab',
      'transport', 'car', 'bike',
      // Vietnamese
      'xe', 'taxi', 'xe buýt', 'xe lửa', 'xăng', 'đỗ xe', 'grab', 'uber',
      'di chuyển', 'ô tô', 'xe máy'
    ],
    'entertainment': [
      // English
      'movie', 'cinema', 'game', 'music', 'concert', 'party', 'fun',
      'entertainment', 'hobby',
      // Vietnamese
      'phim', 'rạp', 'game', 'nhạc', 'hòa nhạc', 'tiệc', 'giải trí', 'sở thích'
    ],
    'health': [
      // English
      'doctor', 'hospital', 'medicine', 'pharmacy', 'health', 'medical',
      'clinic',
      // Vietnamese
      'bác sĩ', 'bệnh viện', 'thuốc', 'nhà thuốc', 'sức khỏe', 'y tế',
      'phòng khám'
    ],
    'essentials': [
      // English
      'grocery', 'market', 'shopping', 'clothes', 'utilities', 'electric',
      'water', 'internet',
      // Vietnamese
      'chợ', 'siêu thị', 'mua sắm', 'quần áo', 'tiện ích', 'điện', 'nước',
      'internet', 'đồ dùng'
    ],
    'work': [
      // English
      'salary', 'bonus', 'freelance', 'work', 'office', 'meeting', 'business',
      // Vietnamese
      'lương', 'thưởng', 'làm thêm', 'công việc', 'văn phòng', 'họp',
      'kinh doanh'
    ],
  };

  /// Extract amount from natural language text
  /// Supports formats like: 50k, 50000, 50,000, 2M, 2.5M
  static int? extractAmount(String text) {
    // Remove Vietnamese currency symbols and common words
    final cleanText = text
        .toLowerCase()
        .replaceAll(RegExp(r'[đvnd₫]'), '')
        .replaceAll(
            RegExp(r'\b(dong|vnd|k|thousand|million|triệu|nghìn)\b'), '');

    // Pattern for amounts with k/M multipliers
    final multiplierPattern =
        RegExp(r'(\d+(?:[.,]\d+)?)\s*([km])', caseSensitive: false);
    final multiplierMatch = multiplierPattern.firstMatch(text.toLowerCase());

    if (multiplierMatch != null) {
      final numStr = multiplierMatch.group(1)!.replaceAll(',', '.');
      final num = double.tryParse(numStr);
      final multiplier = multiplierMatch.group(2)!.toLowerCase();

      if (num != null) {
        switch (multiplier) {
          case 'k':
            return (num * 1000).round();
          case 'm':
            return (num * 1000000).round();
        }
      }
    }

    // Pattern for regular numbers with commas/dots
    final numberPattern = RegExp(r'\b(\d{1,3}(?:[.,]\d{3})*)\b');
    final numberMatch = numberPattern.firstMatch(cleanText);

    if (numberMatch != null) {
      final numStr = numberMatch.group(1)!.replaceAll(',', '');
      return int.tryParse(numStr);
    }

    // Simple number pattern
    final simplePattern = RegExp(r'\b(\d+)\b');
    final simpleMatch = simplePattern.firstMatch(cleanText);

    if (simpleMatch != null) {
      return int.tryParse(simpleMatch.group(1)!);
    }

    return null;
  }

  /// Determine budget category from text content
  static IconCategory detectCategory(String text) {
    final lowerText = text.toLowerCase();

    for (final entry in _categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (lowerText.contains(keyword)) {
          return IconCategory.fromString(entry.key);
        }
      }
    }

    return IconCategory.miscellaneous;
  }

  /// Determine if text indicates income or expense
  static BudgetTypeEnum detectBudgetType(String text) {
    final lowerText = text.toLowerCase();

    // Income indicators
    final incomeKeywords = [
      // English
      'received', 'earned', 'salary', 'bonus', 'income', 'profit', 'freelance',
      'commission',
      // Vietnamese
      'nhận', 'được', 'lương', 'thưởng', 'thu nhập', 'lãi', 'làm thêm',
      'hoa hồng'
    ];

    // Expense indicators (more common, so check income first)
    final expenseKeywords = [
      // English
      'spent', 'paid', 'bought', 'cost', 'expense', 'bill',
      // Vietnamese
      'chi', 'trả', 'mua', 'giá', 'tiền', 'hóa đơn'
    ];

    for (final keyword in incomeKeywords) {
      if (lowerText.contains(keyword)) {
        return BudgetTypeEnum.income;
      }
    }

    for (final keyword in expenseKeywords) {
      if (lowerText.contains(keyword)) {
        return BudgetTypeEnum.expense;
      }
    }

    // Default to expense if unclear
    return BudgetTypeEnum.expense;
  }

  /// Extract date from text (yesterday, today, last week, etc.)
  static DateTime? extractDate(String text) {
    final lowerText = text.toLowerCase();
    final now = DateTime.now();

    // Yesterday
    if (lowerText.contains('yesterday') || lowerText.contains('hôm qua')) {
      return now.subtract(const Duration(days: 1));
    }

    // Today (default)
    if (lowerText.contains('today') || lowerText.contains('hôm nay')) {
      return now;
    }

    // Last week
    if (lowerText.contains('last week') || lowerText.contains('tuần trước')) {
      return now.subtract(const Duration(days: 7));
    }

    // This week
    if (lowerText.contains('this week') || lowerText.contains('tuần này')) {
      return now;
    }

    // Try to parse specific date patterns (DD/MM, MM/DD, etc.)
    final datePattern = RegExp(r'(\d{1,2})[\/\-](\d{1,2})');
    final dateMatch = datePattern.firstMatch(text);

    if (dateMatch != null) {
      final day = int.tryParse(dateMatch.group(1)!);
      final month = int.tryParse(dateMatch.group(2)!);

      if (day != null && month != null && day <= 31 && month <= 12) {
        return DateTime(now.year, month, day);
      }
    }

    return null; // Use current date as default
  }

  /// Generate budget summary text
  static String generateBudgetSummary({
    required List<BudgetModel> budgets,
    required List<TransactionModel> transactions,
    required UserModel user,
    required String locale,
  }) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    // Filter transactions for this month
    final monthlyTransactions = transactions
        .where((t) =>
            t.transactionDate.isAfter(thisMonth) &&
            t.transactionDate.isBefore(nextMonth))
        .toList();

    final totalIncome = monthlyTransactions
        .where((t) => t.transactionType == TransactionTypeEnum.income)
        .fold(0, (sum, t) => sum + t.amount);

    final totalExpense = monthlyTransactions
        .where((t) => t.transactionType == TransactionTypeEnum.expense)
        .fold(0, (sum, t) => sum + t.amount.abs());

    final activeBudgets = budgets
        .where((b) => b.budgetStatusTime == BudgetStatusTime.active)
        .length;

    if (locale == 'vi') {
      return '''📊 **Tóm tắt ngân sách tháng ${now.month}**

💰 Số dư hiện tại: ${user.balanceMoney}
📈 Thu nhập: ${totalIncome.toString()}đ
📉 Chi tiêu: ${totalExpense.toString()}đ
📋 Ngân sách hoạt động: $activeBudgets/${budgets.length}

${_generateBudgetStatusVi(budgets, monthlyTransactions)}''';
    } else {
      return '''📊 **Budget Summary for ${_getMonthName(now.month)}**

💰 Current Balance: ${user.balanceMoney}
📈 Income: \$${totalIncome.toString()}
📉 Expenses: \$${totalExpense.toString()}
📋 Active Budgets: $activeBudgets/${budgets.length}

${_generateBudgetStatusEn(budgets, monthlyTransactions)}''';
    }
  }

  static String _generateBudgetStatusVi(
      List<BudgetModel> budgets, List<TransactionModel> transactions) {
    if (budgets.isEmpty)
      return 'Bạn chưa có ngân sách nào. Hãy tạo ngân sách đầu tiên!';

    final buffer = StringBuffer();
    for (final budget in budgets.take(3)) {
      // Show top 3
      final budgetTransactions =
          transactions.where((t) => t.budgetId == budget.id).toList();
      final spent =
          budgetTransactions.fold(0, (sum, t) => sum + t.amount.abs());
      final percentage = budget.budgetLimit > 0
          ? (spent / budget.budgetLimit * 100).round()
          : 0;

      buffer.writeln(
          '• ${budget.name}: $spentđ/${budget.budgetLimit}đ ($percentage%)');
    }

    if (budgets.length > 3) {
      buffer.writeln('... và ${budgets.length - 3} ngân sách khác');
    }

    buffer.writeln('\nHãy hỏi tôi về bất kỳ ngân sách nào! 😊');
    return buffer.toString();
  }

  static String _generateBudgetStatusEn(
      List<BudgetModel> budgets, List<TransactionModel> transactions) {
    if (budgets.isEmpty)
      return 'You don\'t have any budgets yet. Create your first budget!';

    final buffer = StringBuffer();
    for (final budget in budgets.take(3)) {
      // Show top 3
      final budgetTransactions =
          transactions.where((t) => t.budgetId == budget.id).toList();
      final spent =
          budgetTransactions.fold(0, (sum, t) => sum + t.amount.abs());
      final percentage = budget.budgetLimit > 0
          ? (spent / budget.budgetLimit * 100).round()
          : 0;

      buffer.writeln(
          '• ${budget.name}: \$$spent/\$${budget.budgetLimit} ($percentage%)');
    }

    if (budgets.length > 3) {
      buffer.writeln('... and ${budgets.length - 3} more budgets');
    }

    buffer.writeln('\nFeel free to ask me about any budget! 😊');
    return buffer.toString();
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  /// Extract note/description from transaction text
  static String extractNote(String text) {
    // Remove amount and common transaction words
    String cleanText = text
        .replaceAll(RegExp(r'\d+[kKmM]?'), '') // Remove amounts
        .replaceAll(
            RegExp(r'\b(spent|paid|bought|chi|trả|mua)\b',
                caseSensitive: false),
            '')
        .replaceAll(
            RegExp(r'\b(yesterday|today|hôm qua|hôm nay)\b',
                caseSensitive: false),
            '')
        .trim();

    // If nothing meaningful left, return empty
    if (cleanText.length < 2) return '';

    // Capitalize first letter for better presentation
    if (cleanText.isNotEmpty) {
      cleanText = cleanText[0].toUpperCase() + cleanText.substring(1);
    }

    return cleanText;
  }

  /// Find best matching budget for a transaction
  static BudgetModel? findMatchingBudget(
      String text, List<BudgetModel> budgets) {
    return null;
  }

  /// Format budget name nicely (capitalize first letter of each word)
  static String formatBudgetName(String name) {
    return name
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  /// Determine range date time based on user input
  static RangeDateTimeEnum detectRangeDateTimeType(String text) {
    final lowerText = text.toLowerCase();

    if (lowerText.contains('week') || lowerText.contains('tuần')) {
      return RangeDateTimeEnum.week;
    }

    if (lowerText.contains('month') || lowerText.contains('tháng')) {
      return RangeDateTimeEnum.month;
    }

    if (lowerText.contains('year') || lowerText.contains('năm')) {
      return RangeDateTimeEnum.year;
    }

    if (lowerText.contains('forever') ||
        lowerText.contains('mãi mãi') ||
        lowerText.contains('all time') ||
        lowerText.contains('tất cả')) {
      return RangeDateTimeEnum.allTime;
    }

    // Default to month
    return RangeDateTimeEnum.month;
  }
}
