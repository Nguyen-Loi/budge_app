import 'package:budget_app/data/datasources/apis/chat_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider =
    StateNotifierProvider.autoDispose<ChatController, ChatState>((ref) {
  final chatBaseController = ref.watch(chatBaseControllerProvider.notifier);
  final chatApi = ref.watch(chatAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  final userController = ref.watch(userBaseControllerProvider.notifier);
  final transactionController =
      ref.watch(transactionsBaseControllerProvider.notifier);
  return ChatController(
    chatBaseController: chatBaseController,
    chats: chatApi,
    uid: uid,
    userController: userController,
    transactionController: transactionController,
  );
});

class ChatState {
  final bool isTyping;
  final String? lastError;
  final List<String> suggestions;
  final ChatModel? lastTransaction;
  final bool isProcessingTransaction;
  final bool isCreatingBudget; // Add new state
  final String? currentAction; // Add action description

  const ChatState({
    this.isTyping = false,
    this.lastError,
    this.suggestions = const [],
    this.lastTransaction,
    this.isProcessingTransaction = false,
    this.isCreatingBudget = false,
    this.currentAction,
  });

  ChatState copyWith({
    bool? isTyping,
    String? lastError,
    List<String>? suggestions,
    ChatModel? lastTransaction,
    bool? isProcessingTransaction,
    bool? isCreatingBudget,
    String? currentAction,
  }) {
    return ChatState(
      isTyping: isTyping ?? this.isTyping,
      lastError: lastError ?? this.lastError,
      suggestions: suggestions ?? this.suggestions,
      lastTransaction: lastTransaction ?? this.lastTransaction,
      isProcessingTransaction:
          isProcessingTransaction ?? this.isProcessingTransaction,
      isCreatingBudget: isCreatingBudget ?? this.isCreatingBudget,
      currentAction: currentAction ?? this.currentAction,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  ChatController({
    required ChatBaseController chatBaseController,
    required ChatApi chats,
    required String uid,
    required UserBaseController userController,
    required TransactionsBaseController transactionController,
  })  : _chatBaseController = chatBaseController,
        _chatApi = chats,
        _uid = uid,
        _userController = userController,
        _transactionController = transactionController,
        super(const ChatState()) {
    _initializeSuggestions();
  }

  final ChatBaseController _chatBaseController;
  final ChatApi _chatApi;
  final String _uid;
  final UserBaseController _userController;
  final TransactionsBaseController _transactionController;

  void _initializeSuggestions() {
    final user = _userController.state;
    final locale = user.languageCode;

    final suggestions = locale == 'vi'
        ? [
            "Ăn trưa 50k",
            "Cà phê 30k",
            "Hiện tóm tắt ngân sách",
            "Thêm ghi chú: mua đồ ăn",
            "Xe buýt 25k hôm qua",
          ]
        : [
            "Lunch 50k",
            "Coffee 30k",
            "Show my budget summary",
            "Add note: bought groceries",
            "Transport 25k yesterday",
          ];

    state = state.copyWith(suggestions: suggestions);
  }

  // Get recent chats for AI context
  List<ChatModel> get _recentChats {
    final prompt = _chatBaseController.chats.toList();
    prompt.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return prompt.take(8).toList(); // Increased for better context
  }

  Future<void> sendMessage(BuildContext context,
      {required String message}) async {
    if (message.isEmpty || state.isTyping) {
      if (message.isEmpty) {
        BDialogInfo(
          message: context.loc.dataEmpty,
          dialogInfoType: BDialogInfoType.warning,
        ).present(context);
      }
      return;
    }

    final now = DateTime.now();
    final userChat = ChatModel(
      id: GenId.chat,
      userId: _uid,
      message: message,
      roleTypeValue: RoleChatEnum.user.value,
      createdDate: now,
      updatedDate: now,
    );

    // Detect intent type for UI feedback
    final isTransactionLike = _isTransactionMessage(message);
    final isBudgetCreation = _isBudgetCreationMessage(message);

    state = state.copyWith(
      isTyping: true,
      lastError: null,
      isProcessingTransaction: isTransactionLike,
      isCreatingBudget: isBudgetCreation,
      currentAction: _getActionDescription(message, context),
    );

    // Add user message immediately
    _chatBaseController.addChat(userChat);

    try {
      // Process special commands first
      if (_handleSpecialCommands(message, context)) {
        state = state.copyWith(
          isTyping: false,
          isProcessingTransaction: false,
          isCreatingBudget: false,
          currentAction: null,
        );
        return;
      }

      // Use the new 2-step workflow
      final botChat = await _chatApi.sendMessageWithTwoStepFlow(context,
          history: _recentChats);

      state = state.copyWith(
        isTyping: false,
        isProcessingTransaction: false,
        isCreatingBudget: false,
        currentAction: null,
      );

      botChat.fold(
        (failure) {
          state = state.copyWith(lastError: failure.message);
          showBDialogInfoError(context, message: failure.message);
        },
        (chat) {
          _chatBaseController.addChat(chat);
          state = state.copyWith(lastTransaction: chat);
          _updateSuggestionsBasedOnContext(message, context);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        isProcessingTransaction: false,
        isCreatingBudget: false,
        currentAction: null,
        lastError: e.toString(),
      );
      if (context.mounted) {
        showBDialogInfoError(context,
            message: "Something went wrong. Please try again.");
      }
    }
  }

  bool _handleSpecialCommands(String message, BuildContext context) {
    final user = _userController.state;
    final locale = user.languageCode;
    final lowerMessage = message.toLowerCase().trim();

    // Handle budget summary requests (multi-language)
    if (lowerMessage.contains('budget summary') ||
        lowerMessage.contains('show budget') ||
        lowerMessage.contains('my budgets') ||
        lowerMessage.contains('tóm tắt ngân sách') ||
        lowerMessage.contains('hiện ngân sách') ||
        lowerMessage.contains('ngân sách của tôi')) {
      _handleBudgetSummary(context, locale);
      return true;
    }

    // Handle balance inquiry (multi-language)
    if (lowerMessage.contains('balance') ||
        lowerMessage.contains('money') ||
        lowerMessage.contains('wallet') ||
        lowerMessage.contains('số dư') ||
        lowerMessage.contains('tiền') ||
        lowerMessage.contains('ví')) {
      _handleBalanceInquiry(context, locale);
      return true;
    }

    return false;
  }

  void _handleBudgetSummary(BuildContext context, String locale) {
    final user = _userController.state;
    final transactions = _transactionController.state;

    // Calculate this month's totals
    final now = DateTime.now();
    final thisMonthTransactions = transactions
        .where((t) =>
            t.transaction.transactionDate.month == now.month &&
            t.transaction.transactionDate.year == now.year)
        .toList();

    final totalIncome = thisMonthTransactions
        .where((t) => t.transaction.amount > 0)
        .fold(0, (sum, t) => sum + t.transaction.amount);

    final totalExpense = thisMonthTransactions
        .where((t) => t.transaction.amount < 0)
        .fold(0, (sum, t) => sum + t.transaction.amount.abs());

    final message = locale == 'vi'
        ? """📊 **Tóm tắt ngân sách của bạn**

💰 Số dư hiện tại: ${user.balanceMoney}
📈 Thu nhập tháng này: ${totalIncome.toString()}đ
📉 Chi tiêu tháng này: ${totalExpense.toString()}đ

Bạn đang quản lý tài chính rất tốt! Hãy cho tôi biết nếu bạn cần thêm thông tin chi tiết về bất kỳ ngân sách nào."""
        : """📊 **Your Budget Summary**

💰 Current Balance: ${user.balanceMoney}
📈 This month's income: ${totalIncome.toString()}
📉 This month's expenses: ${totalExpense.toString()}

You're doing great with your finances! Let me know if you'd like details about any specific budget.""";

    final botResponse = ChatModel(
      id: GenId.chat,
      userId: _uid,
      message: message,
      roleTypeValue: RoleChatEnum.assistant.value,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );

    _chatBaseController.addChat(botResponse);
  }

  void _handleBalanceInquiry(BuildContext context, String locale) {
    final user = _userController.state;

    final message = locale == 'vi'
        ? "💰 Số dư hiện tại của bạn là ${user.balanceMoney}. Bạn có muốn thêm giao dịch mới không?"
        : "💰 Your current balance is ${user.balanceMoney}. Would you like to add a new transaction?";

    final botResponse = ChatModel(
      id: GenId.chat,
      userId: _uid,
      message: message,
      roleTypeValue: RoleChatEnum.assistant.value,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );

    _chatBaseController.addChat(botResponse);
  }

  void _updateSuggestionsBasedOnContext(
      String lastMessage, BuildContext context) {
    final user = _userController.state;
    final locale = user.languageCode ?? 'en';
    List<String> newSuggestions = [];

    // If they just added a transaction, suggest related actions
    if (_isTransactionMessage(lastMessage)) {
      newSuggestions.addAll(locale == 'vi'
          ? [
              "Thêm ghi chú: ${_getRandomNote(locale)}",
              "Hiện tóm tắt ngân sách",
              "Số dư của tôi",
            ]
          : [
              "Add note: ${_getRandomNote(locale)}",
              "Show budget summary",
              "My balance",
            ]);
    } else {
      // General suggestions based on language
      newSuggestions.addAll(locale == 'vi'
          ? [
              "Ăn trưa ${_getRandomAmount()}k",
              "Cà phê ${_getRandomAmount()}k",
              "Xe buýt ${_getRandomAmount()}k",
              "Hiện tóm tắt ngân sách",
            ]
          : [
              "Lunch ${_getRandomAmount()}k",
              "Coffee ${_getRandomAmount()}k",
              "Transport ${_getRandomAmount()}k",
              "Show my budget summary",
            ]);
    }

    state = state.copyWith(suggestions: newSuggestions);
  }

  bool _isTransactionMessage(String message) {
    final transactionPatterns = [
      // English patterns
      RegExp(r'\w+\s+\d+k?', caseSensitive: false),
      RegExp(r'paid\s+\w+\s+\d+k?', caseSensitive: false),
      RegExp(r'spent\s+\d+k?\s+on\s+\w+', caseSensitive: false),

      // Vietnamese patterns
      RegExp(r'trả\s+\w+\s+\d+k?', caseSensitive: false),
      RegExp(r'chi\s+\d+k?\s+cho\s+\w+', caseSensitive: false),
      RegExp(r'mua\s+\w+\s+\d+k?', caseSensitive: false),
    ];

    return transactionPatterns
        .any((pattern) => pattern.hasMatch(message.toLowerCase()));
  }

  bool _isBudgetCreationMessage(String message) {
    final lowerMessage = message.toLowerCase();
    final budgetKeywords = [
      'create budget',
      'new budget',
      'add budget',
      'make budget',
      'tạo ngân sách',
      'ngân sách mới',
      'thêm ngân sách'
    ];

    return budgetKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  String _getActionDescription(String message, BuildContext context) {
    final user = _userController.state;
    final locale = user.languageCode;
    final lowerMessage = message.toLowerCase();

    if (_isTransactionMessage(message)) {
      return locale == 'vi'
          ? 'Đang xử lý giao dịch...'
          : 'Processing transaction...';
    }

    if (_isBudgetCreationMessage(message)) {
      return locale == 'vi' ? 'Đang tạo ngân sách...' : 'Creating budget...';
    }

    if (lowerMessage.contains('summary') || lowerMessage.contains('tóm tắt')) {
      return locale == 'vi' ? 'Đang tạo tóm tắt...' : 'Generating summary...';
    }

    return locale == 'vi' ? 'Đang xử lý...' : 'Processing...';
  }

  String _getRandomNote(String locale) {
    final notes = locale == 'vi'
        ? [
            "mua đồ ăn",
            "với bạn bè",
            "ăn nhanh",
            "hóa đơn hàng tháng",
            "thưởng cuối tuần",
          ]
        : [
            "bought groceries",
            "with friends",
            "quick snack",
            "monthly bill",
            "weekend treat",
          ];
    return notes[(DateTime.now().millisecond % notes.length)];
  }

  int _getRandomAmount() {
    final amounts = [25, 30, 35, 40, 45, 50];
    return amounts[(DateTime.now().millisecond % amounts.length)];
  }

  void selectSuggestion(String suggestion) {
    // This would trigger sending the suggestion as a message
    // Implementation depends on how the UI handles suggestion selection
  }

  void clearError() {
    state = state.copyWith(lastError: null);
  }
}
