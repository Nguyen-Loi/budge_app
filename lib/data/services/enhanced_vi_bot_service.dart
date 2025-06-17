import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';

/// Enhanced AI-driven bot service with improved multilingual support
/// and intelligent pattern recognition
class EnhancedViBotService {
  /// Advanced amount extraction supporting multiple formats and currencies
  /// Supports: 50k, 2M, 100,000, $50, 50đ, 50 USD, 2.5M, etc.
  static int? extractAmountAdvanced(String text) {
    final cleanText = text
        .toLowerCase()
        .replaceAll(RegExp(r'[đ₫\$€£¥]'), '') // Remove currency symbols
        .replaceAll(
            RegExp(r'\b(vnd|usd|eur|gbp|jpy)\b'), ''); // Remove currency codes

    // Advanced patterns for different formats
    final patterns = [
      // With multipliers: 50k, 2.5M, 1.2B
      RegExp(r'(\d+(?:[.,]\d+)?)\s*([kmb])', caseSensitive: false),
      // With thousand separators: 1,000,000 or 1.000.000
      RegExp(r'\b(\d{1,3}(?:[.,]\d{3})+)\b'),
      // Simple numbers: 50000, 1234
      RegExp(r'\b(\d+)\b'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(cleanText);
      if (match != null) {
        final numStr = match.group(1)!.replaceAll(',', '.');
        final num = double.tryParse(numStr);

        if (num != null) {
          // Handle multipliers
          if (pattern.pattern.contains('[kmb]')) {
            final multiplier = match.group(2)?.toLowerCase() ?? '';
            switch (multiplier) {
              case 'k':
                return (num * 1000).round();
              case 'm':
                return (num * 1000000).round();
              case 'b':
                return (num * 1000000000).round();
            }
          }
          return num.round();
        }
      }
    }

    return null;
  }

  /// AI-enhanced category detection with context analysis
  static IconCategory detectCategoryAdvanced(String text, {String? context}) {
    final fullContext = '${context ?? ''} $text';
    final lowerContext = fullContext.toLowerCase();

    // Enhanced category mapping with context awareness
    final categoryPatterns = {
      IconCategory.food: _buildFoodPatterns(),
      IconCategory.travel: _buildTravelPatterns(),
      IconCategory.entertainment: _buildEntertainmentPatterns(),
      IconCategory.health: _buildHealthPatterns(),
      IconCategory.essentials: _buildEssentialsPatterns(),
      IconCategory.work: _buildWorkPatterns(),
    };

    // Score-based matching for better accuracy
    Map<IconCategory, int> scores = {};

    for (final entry in categoryPatterns.entries) {
      int score = 0;
      for (final pattern in entry.value) {
        if (lowerContext.contains(pattern)) {
          score += pattern.length.round(); // Longer matches get higher scores
        }
      }
      if (score > 0) {
        scores[entry.key] = score;
      }
    }

    if (scores.isNotEmpty) {
      // Return category with highest score
      return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    return IconCategory.miscellaneous;
  }

  /// Enhanced budget type detection with context analysis
  static BudgetTypeEnum detectBudgetTypeAdvanced(String text, {int? amount}) {
    final lowerText = text.toLowerCase();

    // Income indicators with confidence scoring
    final incomePatterns = [
      'received', 'earned', 'salary', 'bonus', 'income', 'profit', 'freelance',
      'commission', 'dividend', 'interest', 'refund', 'cashback',
      // Vietnamese
      'nhận', 'được', 'lương', 'thưởng', 'thu nhập', 'lãi', 'làm thêm',
      'hoa hồng', 'cổ tức', 'hoàn tiền'
    ];

    // Expense indicators
    final expensePatterns = [
      'spent', 'paid', 'bought', 'cost', 'expense', 'bill', 'purchase',
      'fee', 'charge', 'subscription', 'rent', 'loan',
      // Vietnamese
      'chi', 'trả', 'mua', 'giá', 'tiền', 'hóa đơn', 'phí', 'thuê', 'vay'
    ];

    int incomeScore = 0;
    int expenseScore = 0;

    for (final pattern in incomePatterns) {
      if (lowerText.contains(pattern)) {
        incomeScore += pattern.length;
      }
    }

    for (final pattern in expensePatterns) {
      if (lowerText.contains(pattern)) {
        expenseScore += pattern.length;
      }
    }

    // Context-based inference
    if (amount != null && amount > 0) {
      // Positive amounts are more likely to be income
      incomeScore += 2;
    } else if (amount != null && amount < 0) {
      // Negative amounts are more likely to be expenses
      expenseScore += 2;
    }

    return incomeScore > expenseScore
        ? BudgetTypeEnum.income
        : BudgetTypeEnum.expense;
  }

  /// Advanced date extraction with natural language processing
  static DateTime? extractDateAdvanced(String text) {
    final lowerText = text.toLowerCase();
    final now = DateTime.now();

    // Relative date patterns
    final relativePatterns = {
      // English
      RegExp(r'\b(yesterday|hôm qua)\b'): () =>
          now.subtract(const Duration(days: 1)),
      RegExp(r'\b(today|hôm nay)\b'): () => now,
      RegExp(r'\b(tomorrow|ngày mai)\b'): () =>
          now.add(const Duration(days: 1)),
      RegExp(r'\b(\d+)\s*days?\s*(ago|trước)\b'): () {
        final match =
            RegExp(r'\b(\d+)\s*days?\s*(ago|trước)\b').firstMatch(lowerText);
        final days = int.tryParse(match?.group(1) ?? '0') ?? 0;
        return now.subtract(Duration(days: days));
      },
      RegExp(r'\b(last|tuần)\s*(week|trước)\b'): () =>
          now.subtract(const Duration(days: 7)),
      RegExp(r'\b(this|tuần)\s*(week|này)\b'): () => now,
      RegExp(r'\b(last|tháng)\s*(month|trước)\b'): () =>
          DateTime(now.year, now.month - 1, now.day),
      RegExp(r'\b(this|tháng)\s*(month|này)\b'): () => now,
    };

    for (final entry in relativePatterns.entries) {
      if (entry.key.hasMatch(lowerText)) {
        return entry.value();
      }
    }

    // Specific date patterns: DD/MM, MM/DD, DD-MM, etc.
    final datePatterns = [
      RegExp(r'\b(\d{1,2})[\/\-](\d{1,2})(?:[\/\-](\d{2,4}))?\b'),
      RegExp(
          r'\b(\d{1,2})\s+(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec|tháng)\s*(\d{1,2})?\b'),
    ];

    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(lowerText);
      if (match != null) {
        final day = int.tryParse(match.group(1)!);
        final month = int.tryParse(match.group(2)!);
        final year =
            match.group(3) != null ? int.tryParse(match.group(3)!) : now.year;

        if (day != null &&
            month != null &&
            year != null &&
            day <= 31 &&
            month <= 12) {
          return DateTime(year, month, day);
        }
      }
    }

    return null;
  }

  /// Enhanced note extraction with better context preservation
  static String extractNoteAdvanced(String text) {
    // Remove amount patterns
    String cleanText = text
        .replaceAll(RegExp(r'\d+[kKmMbB]?(?:\.\d+)?'), '')
        .replaceAll(RegExp(r'[đ₫\$€£¥]'), '')
        .replaceAll(
            RegExp(r'\b(vnd|usd|eur|gbp|jpy)\b', caseSensitive: false), '');

    // Remove common action words but preserve context
    final actionWords = [
      // English
      r'\b(spent|paid|bought|received|earned)\b',
      // Vietnamese
      r'\b(chi|trả|mua|nhận|được)\b',
      // Time references
      r'\b(yesterday|today|tomorrow|hôm qua|hôm nay|ngày mai)\b',
    ];

    for (final pattern in actionWords) {
      cleanText =
          cleanText.replaceAll(RegExp(pattern, caseSensitive: false), '');
    }

    // Clean up extra spaces and format nicely
    cleanText = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleanText.length < 2) return '';

    // Capitalize appropriately
    return _capitalizeSmartly(cleanText);
  }

  /// Smart budget matching with fuzzy logic
  static BudgetModel? findMatchingBudgetAdvanced(
      String text, List<BudgetModel> budgets) {
    if (budgets.isEmpty) return null;

    final lowerText = text.toLowerCase();
    Map<BudgetModel, int> scores = {};

    for (final budget in budgets) {
      int score = 0;
      final budgetName = budget.name.toLowerCase();
      final budgetCategory = budget.iconModel.category.name.toLowerCase();

      // Exact name match (highest score)
      if (lowerText.contains(budgetName)) {
        score += 100 + budgetName.length;
      }

      // Partial name match
      final nameWords = budgetName.split(' ');
      for (final word in nameWords) {
        if (word.length > 2 && lowerText.contains(word)) {
          score += 20 + word.length;
        }
      }

      // Category match
      if (lowerText.contains(budgetCategory)) {
        score += 30;
      }

      // Category keyword match
      final detectedCategory = detectCategoryAdvanced(text);
      if (budget.iconModel.category == detectedCategory) {
        score += 50;
      }

      if (score > 0) {
        scores[budget] = score;
      }
    }

    if (scores.isNotEmpty) {
      return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    // Fallback: match by category
    final detectedCategory = detectCategoryAdvanced(text);
    return budgets.firstWhere(
      (b) => b.iconModel.category == detectedCategory,
      orElse: () => budgets.first,
    );
  }

  /// Generate enhanced multilingual budget summary
  static String generateEnhancedBudgetSummary({
    required List<BudgetModel> budgets,
    required List<TransactionModel> transactions,
    required UserModel user,
    required String locale,
    String analysisType = 'summary',
    String? timeframe,
  }) {
    final now = DateTime.now();
    final (startDate, endDate) = _getTimeframeRange(timeframe, now);

    // Filter transactions by timeframe
    final filteredTransactions = transactions
        .where((t) =>
            t.transactionDate.isAfter(startDate) &&
            t.transactionDate.isBefore(endDate))
        .toList();

    final totalIncome = filteredTransactions
        .where((t) => t.transactionType == TransactionTypeEnum.income)
        .fold(0, (sum, t) => sum + t.amount);

    final totalExpense = filteredTransactions
        .where((t) => t.transactionType == TransactionTypeEnum.expense)
        .fold(0, (sum, t) => sum + t.amount.abs());

    final activeBudgets = budgets
        .where((b) => b.budgetStatusTime == BudgetStatusTime.active)
        .length;

    if (locale == 'vi') {
      return _generateVietnameseSummary(
        user: user,
        budgets: budgets,
        transactions: filteredTransactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        activeBudgets: activeBudgets,
        timeframe: timeframe ?? 'tháng này',
      );
    } else {
      return _generateEnglishSummary(
        user: user,
        budgets: budgets,
        transactions: filteredTransactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        activeBudgets: activeBudgets,
        timeframe: timeframe ?? 'this month',
      );
    }
  }

  // Helper methods for pattern building
  static List<String> _buildFoodPatterns() => [
        // English
        'lunch', 'dinner', 'breakfast', 'coffee', 'restaurant', 'food', 'eat',
        'meal', 'snack', 'drink', 'cafe', 'pizza', 'burger', 'sandwich',
        'grocery', 'supermarket', 'market', 'cooking', 'recipe',
        // Vietnamese
        'ăn', 'uống', 'cơm', 'phở', 'cafe', 'cà phê', 'trưa', 'sáng', 'tối',
        'nhà hàng', 'quán', 'đồ ăn', 'bánh', 'nước', 'chợ', 'siêu thị',
        'nấu ăn',
      ];

  static List<String> _buildTravelPatterns() => [
        // English
        'travel', 'vacation', 'hotel', 'flight', 'trip', 'tour', 'holiday',
        'booking', 'airbnb', 'sightseeing', 'taxi', 'bus', 'train', 'gas',
        'fuel',
        'parking', 'uber', 'grab', 'transport', 'car', 'bike', 'subway',
        'ticket', 'toll',
        // Vietnamese
        'du lịch', 'nghỉ', 'khách sạn', 'máy bay', 'chuyến đi', 'tour', 'lễ',
        'đặt phòng', 'tham quan', 'xe', 'taxi', 'xe buýt', 'xe lửa', 'xăng',
        'đỗ xe',
        'grab', 'uber', 'di chuyển', 'ô tô', 'xe máy', 'tàu', 'vé', 'cầu phí',
      ];

  static List<String> _buildEntertainmentPatterns() => [
        // English
        'movie', 'cinema', 'game', 'music', 'concert', 'party', 'fun',
        'entertainment', 'hobby', 'sport', 'gym', 'book', 'netflix',
        // Vietnamese
        'phim', 'rạp', 'game', 'nhạc', 'hòa nhạc', 'tiệc', 'giải trí',
        'sở thích', 'thể thao', 'gym', 'sách', 'xem phim',
      ];

  static List<String> _buildHealthPatterns() => [
        // English
        'doctor', 'hospital', 'medicine', 'pharmacy', 'health', 'medical',
        'clinic', 'dental', 'checkup', 'insurance', 'vitamin',
        // Vietnamese
        'bác sĩ', 'bệnh viện', 'thuốc', 'nhà thuốc', 'sức khỏe', 'y tế',
        'phòng khám', 'nha khoa', 'khám', 'bảo hiểm', 'vitamin',
      ];

  static List<String> _buildEssentialsPatterns() => [
        // English
        'grocery', 'market', 'shopping', 'clothes', 'utilities', 'electric',
        'water', 'internet', 'phone', 'rent', 'mortgage', 'insurance',
        // Vietnamese
        'chợ', 'siêu thị', 'mua sắm', 'quần áo', 'tiện ích', 'điện', 'nước',
        'internet', 'điện thoại', 'thuê nhà', 'vay nhà', 'bảo hiểm',
      ];

  static List<String> _buildWorkPatterns() => [
        // English
        'salary', 'bonus', 'freelance', 'work', 'office', 'meeting', 'business',
        'project', 'client', 'contract', 'commission',
        // Vietnamese
        'lương', 'thưởng', 'làm thêm', 'công việc', 'văn phòng', 'họp',
        'kinh doanh', 'dự án', 'khách hàng', 'hợp đồng', 'hoa hồng',
      ];

  static String _capitalizeSmartly(String text) {
    if (text.isEmpty) return text;

    // Split by sentences and capitalize each
    final sentences = text.split(RegExp(r'[.!?]+'));
    final capitalizedSentences = sentences.map((sentence) {
      final trimmed = sentence.trim();
      if (trimmed.isEmpty) return trimmed;
      return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
    });

    return capitalizedSentences.join('. ').trim();
  }

  static (DateTime, DateTime) _getTimeframeRange(
      String? timeframe, DateTime now) {
    if (timeframe == null || timeframe.isEmpty) {
      // Default to current month
      return (
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 0)
      );
    }

    final lowerTimeframe = timeframe.toLowerCase();

    if (lowerTimeframe.contains('week') || lowerTimeframe.contains('tuần')) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      return (weekStart, weekStart.add(const Duration(days: 6)));
    }

    if (lowerTimeframe.contains('month') || lowerTimeframe.contains('tháng')) {
      return (
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 0)
      );
    }

    if (lowerTimeframe.contains('year') || lowerTimeframe.contains('năm')) {
      return (DateTime(now.year, 1, 1), DateTime(now.year, 12, 31));
    }

    // Default to current month
    return (
      DateTime(now.year, now.month, 1),
      DateTime(now.year, now.month + 1, 0)
    );
  }

  static String _generateVietnameseSummary({
    required UserModel user,
    required List<BudgetModel> budgets,
    required List<TransactionModel> transactions,
    required int totalIncome,
    required int totalExpense,
    required int activeBudgets,
    required String timeframe,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('📊 **Tóm tắt ngân sách $timeframe**\n');
    buffer.writeln('💰 Số dư hiện tại: ${user.balanceMoney}');
    buffer.writeln('📈 Thu nhập: $totalIncomeđ');
    buffer.writeln('📉 Chi tiêu: $totalExpenseđ');
    buffer
        .writeln('📋 Ngân sách hoạt động: $activeBudgets/${budgets.length}\n');

    if (budgets.isEmpty) {
      buffer
          .writeln('Bạn chưa có ngân sách nào. Hãy tạo ngân sách đầu tiên! 🎯');
    } else {
      buffer.writeln('**Chi tiết ngân sách:**');
      for (final budget in budgets.take(3)) {
        final budgetTransactions =
            transactions.where((t) => t.budgetId == budget.id).toList();
        final spent =
            budgetTransactions.fold(0, (sum, t) => sum + t.amount.abs());
        final percentage = budget.budgetLimit > 0
            ? (spent / budget.budgetLimit * 100).round()
            : 0;

        final status = percentage > 100
            ? '⚠️'
            : percentage > 80
                ? '🟡'
                : '✅';
        buffer.writeln(
            '$status ${budget.name}: $spentđ/${budget.budgetLimit}đ ($percentage%)');
      }

      if (budgets.length > 3) {
        buffer.writeln('... và ${budgets.length - 3} ngân sách khác');
      }
    }

    buffer.writeln('\nHãy hỏi tôi về bất kỳ ngân sách nào! 😊');
    return buffer.toString();
  }

  static String _generateEnglishSummary({
    required UserModel user,
    required List<BudgetModel> budgets,
    required List<TransactionModel> transactions,
    required int totalIncome,
    required int totalExpense,
    required int activeBudgets,
    required String timeframe,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('📊 **Budget Summary for $timeframe**\n');
    buffer.writeln('💰 Current Balance: ${user.balanceMoney}');
    buffer.writeln('📈 Income: \$$totalIncome');
    buffer.writeln('📉 Expenses: \$$totalExpense');
    buffer.writeln('📋 Active Budgets: $activeBudgets/${budgets.length}\n');

    if (budgets.isEmpty) {
      buffer.writeln(
          'You don\'t have any budgets yet. Create your first budget! 🎯');
    } else {
      buffer.writeln('**Budget Details:**');
      for (final budget in budgets.take(3)) {
        final budgetTransactions =
            transactions.where((t) => t.budgetId == budget.id).toList();
        final spent =
            budgetTransactions.fold(0, (sum, t) => sum + t.amount.abs());
        final percentage = budget.budgetLimit > 0
            ? (spent / budget.budgetLimit * 100).round()
            : 0;

        final status = percentage > 100
            ? '⚠️'
            : percentage > 80
                ? '🟡'
                : '✅';
        buffer.writeln(
            '$status ${budget.name}: \$$spent/\$${budget.budgetLimit} ($percentage%)');
      }

      if (budgets.length > 3) {
        buffer.writeln('... and ${budgets.length - 3} more budgets');
      }
    }

    buffer.writeln('\nFeel free to ask me about any budget! 😊');
    return buffer.toString();
  }
}
